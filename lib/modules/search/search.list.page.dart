//Auto code generated from xml definition 2022-03-25 16:36:18.397158 -0400 EDT
//Search
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_search_ui/modules/search/facet.ds.dart';
import 'package:ez_search_ui/modules/search/search.ds.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:ez_search_ui/common/base_cubit.dart';
import 'package:ez_search_ui/common/global.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/helper/UIHelper.dart';
import 'package:ez_search_ui/helper/commondropdown.dart';
import 'package:ez_search_ui/helper/utilfunc.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.cubit.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.model.dart';
import 'package:ez_search_ui/modules/search/SearchResult.dart';
import 'package:ez_search_ui/modules/search/search.cubit.dart';
import 'package:ez_search_ui/modules/search/search.repo.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:universal_html/html.dart' as html;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

SearchResult? result;
Map<String, String> qParsedMap = <String, String>{};
List<RptQueryModel> rptList = <RptQueryModel>[];
RptQueryModel curRptQuery =
    RptQueryModel(id: '', name: '', division: '', page: '', CustomData: '');
Map<String, bool> facetsFilter = {};
Map<String, DataGridController> facetDGctrls = {};

class _SearchPageState extends State<SearchPage> {
  late bool isWebOrDesktop;
  final DataGridController _dgController = DataGridController();
  final TextEditingController qTxtCtrl = TextEditingController();
  final TextEditingController nqNameCtrl = TextEditingController();
  final TextEditingController pgIndexCtrl = TextEditingController();
  final TextEditingController pgSizeCtrl = TextEditingController();
  final TextEditingController sincetimeCtrl = TextEditingController();
  final TextEditingController sinceOnCtrl = TextEditingController();
  final TextEditingController totRecCtrl = TextEditingController();
  bool hasQueryChanged = false;

  final Map<String, String> sinceAgoDD = {
    "1": "seconds",
    "2": "minutes",
    "3": "hours",
    "4": "days"
  };
  late String sinceAgoSelection;
  //final TextEditingController pgIndexCtrl = TextEditingController();

  final fn = FocusNode();
  final gfn = FocusNode();
  final nqfn = FocusNode();
  bool isQueryModifiedByUser = false;
  bool enablePagerLoad = true;
  var regEx = RegExp("select |from |where |limit |since |facets |sort ");

  /// Determine to decide whether the device in landscape or in portrait.
  late bool isLandscapeInMobileView;

  @override
  void initState() {
    isWebOrDesktop = Global.isWeb || Global.isDesktop;
    // if (BlocProvider.of<RptQueryCubit>(context).state is! BaseListSuccess) {
    BlocProvider.of<RptQueryCubit>(context).getAll();

    // for (var item in regEx.allMatches(
    //     "select * from testing where a:b,cc:test sort newsort, sort2 limit 10,20")) {
    //   print(
    //       "gropu name: ${item.groupNames.first} start: ${item.start}, end ${item.end} ");
    // }
    // qTxtCtrl.text =
    //     "select * from testing where a:b,cc:test sort newsort, sort2 limit 10,20";
    // print("_parsequery ${_parseQuery()}");
    sinceAgoSelection = sinceAgoDD["1"] as String;
    pgSizeCtrl.text = "25";

    super.initState();
  }

  Map<String, String> _parseQuery() {
    qTxtCtrl.text = curRptQuery.CustomData.trim(); //qTxtCtrl.text.trim();
    var grps = regEx.allMatches(qTxtCtrl.text.toLowerCase());
    var curIdx = 0;
    var curKey = '';
    var maxLen = qTxtCtrl.text.length;
    print("for grps maxlen $maxLen");
    Map<String, String> map = <String, String>{};
    RegExpMatch? item;
    for (item in grps) {
      if (curIdx > 0) {
        var nt = qTxtCtrl.text.substring(curIdx, item.start).trim();
        print(
            "for grps if ${item.start},${item.end}[${curKey.substring(0, 3)}]=$nt");
        map[curKey.substring(0, 3).toLowerCase()] = nt;
      }
      curKey = qTxtCtrl.text.substring(item.start, item.end);
      curIdx = item.end;
      print("for grps  ${item.start} ${item.end}");
    }
    print("regex map grp ${map.keys} ${map.values}");
    item = grps.last;
    print(
        "for grps out side grps $curIdx $maxLen, ${maxLen - item.end}  ${(curIdx < maxLen)}");
    if (curIdx < maxLen) {
      curKey = qTxtCtrl.text.substring(item.start, item.end);
      print("for grps $curKey");
      var nt = qTxtCtrl.text.substring(item.end);
      print("for grps out side grps ${item.start} ${item.end} $nt");

      map[curKey.substring(0, 3).toLowerCase()] = nt;
      //qTxtCtrl.text.substring(item.end, maxLen - item.end).trim();
    }
    print("regex map grp ${map.keys} ${map.values}");
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Row(children: [
            _rptDropDownBlocBuilder(),
            Expanded(child: _buildqueryEditTb()),
            IconButton(
                onPressed: () {
                  _showQueryInfoDialog();
                },
                icon: Icon(Icons.info_rounded)),
            TextButton(onPressed: _execSearchQuery, child: Text("Run")),
            BlocBuilder<RptQuerySaveCubit, RptQueryState>(
              builder: (context, state) {
                return Column(
                  children: [
                    IconButton(
                        onPressed: _saveRptQuery,
                        icon: Icon(Icons.save_outlined),
                        tooltip: "Save"),
                    if (state is RptQueryLoading) CircularProgressIndicator(),
                    if (state is RptQueryFailure) Text(state.errorMsg),
                  ],
                );
              },
            ),
            BlocBuilder<RptQuerySaveCubit, RptQueryState>(
                builder: (context, state) {
              return Column(
                children: [
                  IconButton(
                      onPressed: () {
                        _showMaterialDialog();
                      },
                      icon: Icon(Icons.save_alt_sharp),
                      tooltip: "Save as"),
                  if (state is BaseLoading) CircularProgressIndicator(),
                  if (state is RptQueryFailure) Text(state.errorMsg),
                ],
              );
            }),
            BlocBuilder<RptQuerySaveCubit, RptQueryState>(
                builder: (context, state) {
              return Column(
                children: [
                  IconButton(
                      onPressed: () {
                        exportToCsvDialog();
                      },
                      icon: Icon(Icons.import_export_outlined),
                      tooltip: "Csv export"),
                  if (state is BaseLoading) CircularProgressIndicator(),
                  if (state is RptQueryFailure) Text(state.errorMsg),
                ],
              );
            }),
          ]),
          Expanded(child: _sfGridBuildBlocBuilder()),
        ],
      );
    }));
  }

  void exportToCsvDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please provide start and end page index'),
            content: buildStartandEndPage(),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                child: TextButton(
                    onPressed: () {
                      _dismissDialog(context);
                    },
                    child: Text('Cancel')),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                child: TextButton(
                  onPressed: () {
                    generateCSV();
                    _dismissDialog(context);
                  },
                  child: Text('Export'),
                ),
              ),
            ],
          );
        });
  }

  Row buildStartandEndPage() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
            child: TextField(
              onChanged: (val) {},
              decoration: InputDecoration(labelText: "Start Page"),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
            child: TextField(
              controller: pgIndexCtrl,
              //keyboardType: TextInputType.multiline,
              //textInputAction: TextInputAction.none,
              onChanged: (val) {},
              decoration: InputDecoration(
                  labelText: "End Page [${_getMaxPagination()}]"),
            ),
          ),
        ),
      ],
    );
  }

  void generateCSV() async {
    SearchRepo repo = SearchRepo();
    //pgIndexCtrl.text =
    _constructQueryFromCtrls();

    if (qTxtCtrl.text.isEmpty) {
      //TODO show nice way
      _showSnackBarMessage("Please select a query defintion.");
      return;
    }
    try {
      result = await repo.getSearchData(qTxtCtrl.text);
    } on Exception catch (e) {
      _showSnackBarMessage("Failed $e");
      print("Failed $e");
      return;
    }

    List<String> rowHeader = [];
    for (var fieldName in result!.fields!) {
      rowHeader.add(fieldName);
    }
    List<List<dynamic>> rows = [];
    //First add entire row header into our first row
    rows.add(rowHeader);
    //Now lets add 5 data rows

    for (var row in result!.resultRow!) {
      List<dynamic> dataRow = [];
      int colIndex = 0;
      for (var key in rowHeader) {
        dataRow.add('');
        if (row[key] != null) {
          dataRow[colIndex] = row[key];
        }
        colIndex++;
      }
      rows.add(dataRow);
    }
    String csv = const ListToCsvConverter().convert(rows);
//this csv variable holds entire csv data
//Now Convert or encode this csv string into utf8
    final bytes = utf8.encode(csv);
//NOTE THAT HERE WE USED HTML PACKAGE
    final blob = html.Blob([bytes]);
//It will create downloadable object
    final url = html.Url.createObjectUrlFromBlob(blob);
//It will create anchor to download the file
    final DateFormat format = DateFormat("yyy-MM-dd-hh-mm-ss");
    final String formated = format.format(DateTime.now());
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'export_$formated.csv';
//finally add the csv anchor to body
    html.document.body!.children.add(anchor);
// Cause download by calling this function
    anchor.click();
//revoke the object
    html.Url.revokeObjectUrl(url);
  }

  RawKeyboardListener _buildqueryEditTb() {
    return RawKeyboardListener(
        focusNode: gfn,
        autofocus: true,
        onKey: (RawKeyEvent e) {
          if (e.logicalKey.keyId >= 32 && e.logicalKey.keyId <= 122) {
            isQueryModifiedByUser = true;
          }
          if ((e.isKeyPressed(LogicalKeyboardKey.numpadEnter) ||
                  e.isKeyPressed(LogicalKeyboardKey.enter)) &&
              qTxtCtrl.text.isNotEmpty) {
            if (isQueryModifiedByUser) {
              curRptQuery.CustomData = qTxtCtrl.text;
              isQueryModifiedByUser = false;
            }

            //isQueryModifiedByUser = false;
            _execSearchQuery();
            //print("keypressed ${e.data.logicalKey}  ${e.character}");
          }
        },
        child: TextField(
          controller: qTxtCtrl,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.none,

          focusNode: fn,

          //one

          //readOnly: true,
        ));
  }

  void _execSearchQuery() {
    //print("_execSearchQuery() ${curRptQuery.CustomData} ${qTxtCtrl.text}");
    if (isQueryModifiedByUser) {
      curRptQuery.CustomData = qTxtCtrl.text;
      isQueryModifiedByUser = false;
    }
    if (hasQueryChanged) _constructQueryFromCtrls();

    BlocProvider.of<SearchCubit>(context).getAllSearchs(qTxtCtrl.text);
  }

  void _showQueryInfoDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Query Helper'),
              content: SingleChildScrollView(
                child: RichText(
                  overflow: TextOverflow.clip,
                  text: TextSpan(
                      //text: "Search query helper",
                      style: DefaultTextStyle.of(context).style,
                      children: const <TextSpan>[
                        TextSpan(
                            text:
                                'Search query consist of multiple clauses {select |from |where |limit |since |facets |sort}. It Looks like a SQL query.\nClauses order can be any order, parse engine able to parse them."from" clause must be presented in any query.\nIndex document fileds are case sensitive. "\nselect clause contains list of fields, you can also provide * to pull all the index fields in a document. {{baseUrl}}/api/getfields?indexName=nameofindex can help get the list of fields\n'),
                        TextSpan(
                            text:
                                'from clause contains index document name in which search can be executed. You can get exact index name from api {{baseUrl}}/api/getindexes or gost search UI\n'),
                        TextSpan(
                            text:
                                'where clause contains search conditions. All coditions are separated by coma char and or not can be acheived as mentioned Require, Optional and Exclusion section\n'),
                        TextSpan(
                            text:
                                'limit clause helps to fetch no of records on top where condition. The format of is {limit startIndex,No of record to be taken}, start index should be 0 based. examble limit 0,10 which fetches first 10 records \n'),
                        TextSpan(
                            text:
                                'since clause also helps filter condition for range fields. Time line based search. It helps mainly for timelime search like {since startDate:30 minutes ago}  \n'),
                        TextSpan(
                            text:
                                'facets clause also to get the facets data. {facets brand:no of records} example {facets brand:30} it fecths facets only first 30 records along with count.\n'),
                        TextSpan(
                            text:
                                'sort clause helps ordering the result data set. {sort +startdate,-brand} starting char [+/-] correspond ascending/descending\n\n'),
                        TextSpan(
                            text: "Field Scoping\n",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                "You can qualify the field for these searches by prefixing them with the name of the field separated by a colon.\n"),
                        TextSpan(
                            text:
                                '[name:ram] parsing field logic is upto [:] "name" field name and "ram" should match in the index document. Would apply as match query\n'),
                        TextSpan(
                            text:
                                '[select id,name,age from indexName where name:ram,age:>40,+age:<=50,startDt>2022-01-01T01:01:00Z facets name limit 1, 10]\n\n'),
                        TextSpan(
                            text: "Terms query\n",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                'In where condition if the filed name missed then automatically construct the term query in the below query "ram" will searched any document using term query which mean find the "ram" any where in the document on all text fields'),
                        TextSpan(
                            text:
                                'Sample query \n[select id,name,age from indexName where ram,age:>40,+age:<=50,startDt>2022-01-01T01:01:00Z facets name limit 1, 10]\n\n'),
                        TextSpan(
                            text: "Regular Expressions\n",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                'You can use regular expressions in addition to using terms by wrapping the expression in forward slashes (/).\n[name:/r*/] in the value part starts with forward slash then apply regex query\n\n'),
                        TextSpan(
                            text:
                                'Sample query \n[select id,name,age from indexName where name:/r*/,age:>40,+age:<=50,startDt>2022-01-01T01:01:00Z facets name limit 1, 10]\n\n'),
                        TextSpan(
                            text: "Required, Optional, and Exclusion\n",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                'When your query string includes multiple items, by default these are placed into the SHOULD clause of a Boolean Query.\nYou can change this by prefixing your items with a "+" or "-". The "+" Prefixing with plus places that item in the MUST portion of the boolean query. \nThe "-" Prefixing with a minus places that item in the MUST NOT portion of the boolean query.\n\n'),
                        TextSpan(
                            text:
                                'Sample query \n[select id,name,age from indexName where name:ram,age:>40,+age:<=50,startDt>2022-01-01T01:01:00Z facets name limit 1, 10]\n'),
                        TextSpan(
                            text: "Numeric / Date Ranges\n",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                'You can perform ranges by using the >, >=, <, and <= operators, followed by a valid numeric/datetime value\n\n'),
                        TextSpan(
                            text: "Escaping\n",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                'The following quoted string enumerates the characters which may be escaped:\n+-=&|><!(){}[]^\\"~*?:\\\\/\nNOTE: this list contains the space character.\n'),
                        TextSpan(
                            text:
                                'In order to escape these characters, they are prefixed with the \ (backslash) character. In all cases, using the escaped version produces the character itself and is not interpreted by the lexer.\n\n'),
                        TextSpan(
                            text:
                                'Example:\n"my\\ name" will be interpreted as a single argument to a match query with the value “my name”.\nContains {a\\" character} will be interpreted as a single argument to a phrase query with the value contains {a" character}.\n\n'),
                        TextSpan(
                            text: "Date field\n",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                'It is formated and converted to UTC time zone as given below\nExamaple\n2022-02-19T20:49:03Z  golang format is [2006-01-02T15:04:05Z] which is equalant [yyyy-MM-ddThh:mm:ssZ] while searching must follow the same format.\n'),
                      ]),
                ),
              ));
        });
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New Query Name'),
            content: _buildNewQeryNameTb(),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _dismissDialog(context);
                  },
                  child: Text('Close')),
              TextButton(
                onPressed: () {
                  _validateAndSaveForNewQuery();
                  _dismissDialog(context);
                },
                child: Text('Save'),
              )
            ],
          );
        });
  }

  void _saveRptQuery() {
    curRptQuery.CustomData = qTxtCtrl.text;
    BlocProvider.of<RptQuerySaveCubit>(context)
        .createOrUpdateRptQuery(curRptQuery);
    BlocProvider.of<RptQueryCubit>(context).getAll();
  }

  RawKeyboardListener _buildNewQeryNameTb() {
    return RawKeyboardListener(
        focusNode: nqfn,
        autofocus: true,
        onKey: (RawKeyEvent e) {
          print("on key%${nqNameCtrl.text}");
          if ((e.isKeyPressed(LogicalKeyboardKey.numpadEnter) ||
                  e.isKeyPressed(LogicalKeyboardKey.enter)) &&
              nqNameCtrl.text.isNotEmpty) {
            _validateAndSaveForNewQuery();
          }
        },
        child: TextField(
          controller: nqNameCtrl,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.none,
          //one

          //readOnly: true,
        ));
  }

  void _validateAndSaveForNewQuery() {
    bool isExist = false;

    for (var item in rptList) {
      print("rptName loop $item");
      if (item.name == nqNameCtrl.text) {
        isExist = true;
        break;
      }
    }

    if (isExist && rptList.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Query Name is already exist try with different name")));
    } else {
      var r = Random();
      String rn = r.nextInt(100).toString();

      curRptQuery = RptQueryModel(
          id: "",
          name: nqNameCtrl.text,
          division: UtilFunc.getNamespace(),
          page: "search",
          CustomData: qTxtCtrl.text);
      rptList.add(curRptQuery);
      _saveRptQuery();
    }
  }

  _dismissDialog(BuildContext context) {
    Navigator.pop(context);
  }

  void _showSnackBarMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  int _getStartIndex() {
    var startInd = int.parse(pgIndexCtrl.text) * int.parse(pgSizeCtrl.text);
    return startInd;
  }

  void _constructQueryFromCtrls() {
    var sb = StringBuffer();
    if (qParsedMap["sel"] != null) {
      sb.write('select ${qParsedMap["sel"]} ');
    }
    if (qParsedMap["fro"] != null) {
      sb.write('from ${qParsedMap["fro"]} ');
    }
    if (qParsedMap["whe"] != null) {
      sb.write('where ${qParsedMap["whe"]} ');
      if (facetsFilter.keys.isNotEmpty) {
        sb.write(', +${facetsFilter.keys.join(",+")}');
      }
    }
    print("whe|keys ${facetsFilter.keys}");
    if (qParsedMap["whe"] == null && facetsFilter.keys.isNotEmpty) {
      var fjoin = facetsFilter.keys.join(",+");
      print("whenew $fjoin");
      sb.write('where +$fjoin ');
    }

    if (sinceOnCtrl.text.isNotEmpty) {
      sb.write(
          "since ${sinceOnCtrl.text}:${sincetimeCtrl.text} $sinceAgoSelection ago ");
    }
    if (qParsedMap["sor"] != null) {
      sb.write("sort ${qParsedMap["sor"]} ");
    }
    // if (qParsedMap["lim"] != null) {
    print("start idnex ${pgIndexCtrl.text}");
    if (pgIndexCtrl.text.isNotEmpty) {
      sb.write("limit ${_getStartIndex()},${pgSizeCtrl.text} ");
    }
    if (qParsedMap["fac"] != null) {
      sb.write("facets ${qParsedMap["fac"]} ");
    }
    print("finalquery${sb.toString().trim()}");
    qTxtCtrl.text = sb.toString().trim();
    hasQueryChanged = false;
    setState(() {});
  }

  void _updateCtrlsFromQuery() {
    totRecCtrl.text = result!.total.toString();
    qParsedMap = _parseQuery();
    if (qParsedMap["lim"] != null) {
      var lim = qParsedMap["lim"];
      var splits = lim?.split(",");
      if (splits!.isNotEmpty) pgSizeCtrl.text = splits[1];
    }
    if (qParsedMap["sin"] != null) {
      List<String> clause = (qParsedMap['sin'] ?? '').split(" ");
      if (clause.length < 3) {
        _showSnackBarMessage(
            "Since clause must have 3 words like since startDt:30 minutes ago");
      }
      var sinceOn = clause[0].split(":");
      if (sinceOn.length == 1) {
        _showSnackBarMessage("Since clause field name is missing.");
      } else {
        sinceOnCtrl.text = sinceOn[0];
        sincetimeCtrl.text = sinceOn[1];
      }

      for (var item in sinceAgoDD.values) {
        print("since ago| ${clause[1]}| $item");
        if (item == clause[1]) {
          sinceAgoSelection = item;
          break;
        }
      }
    }
    hasQueryChanged = false;
    isQueryModifiedByUser = false;
  }

  Widget _sfGridBuildBlocBuilder() {
    // return result != null
    //     ? Center(
    //         child: Text("No data to display"),
    //       )
    //     : _buildSearchGrid();
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return SizedBox(
              height: 16,
              width: 16,
              child: Center(
                  child: const CircularProgressIndicator(
                strokeWidth: 1.5,
              )));
        } else if (state is SearchFailure) {
          return Center(
            child: Text(state.errorMsg),
          );
        } else if (state is SearchSuccess) {
          result = state.props;
          _updateCtrlsFromQuery();
          return _buildSearchGrid();
        } else if (state is SearchEmpty) {
          return Text(AppValues.noRecFoundExpLbl);
        }
        return const Text("Select a query to view data.");
      },
    );
  }

  BlocBuilder<RptQueryCubit, BaseState> _rptDropDownBlocBuilder() {
    return BlocBuilder<RptQueryCubit, BaseState>(
      builder: (context, state) {
        if (state is BaseListSuccess) {
          rptList = state.list as List<RptQueryModel>;
        }
        if (state is BaseLoading) {
          return const CircularProgressIndicator();
        } else {
          return Column(
            children: [
              CommonDropDown(
                k: "rptQuery",
                uniqueValues: rptList.map((e) => e.id).toList(),
                lblTxt: "Query defition",
                onChanged: (String? val) {
                  facetsFilter.clear();
                  if (val != null) {
                    for (var item in rptList) {
                      if (item.id == val) {
                        curRptQuery = item;
                        qTxtCtrl.text = item.CustomData;
                        fn.requestFocus();
                      }
                    }
                  }
                },
                ddDataSourceNames: rptList.map((e) => e.name).toList(),
              ),
              if (state is BaseFailure) Text(state.errorMsg),
              if (state is BaseEmpty) Text(AppValues.noRecFoundExpLbl)
            ],
          );
        }
      },
    );
  }

  int _getMaxPagination() {
    int maxCount = 0;
    if (result != null)
      (result!.total / int.parse(pgSizeCtrl.text)).floorToDouble().toInt();
    return maxCount;
  }

  Widget _buildSearchGrid() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(4),
            child: Column(
              children: _buildSFGridForFacet(),
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.black))),
              child: Column(children: [
                _buildQueryCtrls(),
                Padding(
                  padding: EdgeInsets.all(AppValues.sfGridPadding),
                  child: SfDataGrid(
                      allowSorting: true,
                      isScrollbarAlwaysShown: true,
                      columnWidthMode: ColumnWidthMode.auto,
                      source:
                          SearchDatagridSource(curRptQuery, context, result!),
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.vertical,
                      rowHeight: 30,
                      headerRowHeight: 35,
                      selectionMode: SelectionMode.single,
                      allowPullToRefresh: true,
                      //navigationMode: GridNavigationMode.cell,
                      controller: _dgController,
                      // onSelectionChanging: (addedRows, removedRows) {
                      // },
                      columns: _buildGirdColumn),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTerms(Map<String, dynamic> terms) {
    List<Widget> widgets = [];
    //filtered term from search result
    for (var key in terms.keys) {
      bool isChecked = false;
      if (facetsFilter.isNotEmpty && facetsFilter.keys.contains(key)) {
        isChecked = true;
      }
      var w = Row(
        children: [
          Checkbox(
              value: isChecked,
              onChanged: (val) {
                if (val = false) {
                  facetsFilter.remove(key);
                } else {
                  facetsFilter[key] = true;
                }
                _execSearchQuery();
              }),
          Expanded(
            child: InkWell(
              onTap: () {
                if (facetsFilter[key] != null) {
                  facetsFilter.remove(key);
                } else {
                  facetsFilter[key] = true;
                }
                _execSearchQuery();
              },
              child: Text('$key(${terms[key]})'),
            ),
          )
        ],
      );
      widgets.add(w);
    }
    return widgets;
  }

  List<Widget> _buildSFGridForFacet() {
    var fr = result!.facetResult!;
    List<Widget> sfgList = [];
    var gKeys = fr.keys.toList();
    if (facetsFilter.isNotEmpty) {
      sfgList.add(Container(
        padding: const EdgeInsets.all(4),
        child: const Text(
          "Selected filter(s)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ));
      var facetKeys = facetsFilter.keys.toList();
      for (var i in facetKeys) {
        sfgList.add(Container(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.indeterminate_check_box),
                  onPressed: () {
                    hasQueryChanged = true;
                    facetsFilter.remove(i);
                    _execSearchQuery();
                  },
                ),
                Text(i)
              ],
            )));
      }
    }

    for (var item in gKeys) {
      if (sfgList.isNotEmpty) {
        sfgList.add(const SizedBox(
          height: 8,
        ));
      }
      var _fgCtrl = DataGridController();
      var srcItems = FacetDatagridSource(fr[item]!, item, _fgCtrl);
      var sf = Container(
          height: 60 + srcItems.rows.length * 40,
          // padding: EdgeInsets.all(4),
          //border: Border(left: BorderSide(color: Colors.black)))
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(color: Colors.black),
                  right: BorderSide(color: Colors.black),
                  top: BorderSide(color: Colors.black),
                  bottom: BorderSide(color: Colors.black))),
          child: Padding(
            padding: AppValues.formFieldPadding,
            child: SfDataGrid(
                //allowSorting: true,

                isScrollbarAlwaysShown: true,
                columnWidthMode: ColumnWidthMode.auto,
                source: srcItems,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                rowHeight: 40,
                headerRowHeight: 45,
                showCheckboxColumn: true,
                selectionMode: SelectionMode.multiple,

                //allowPullToRefresh: true,
                //navigationMode: GridNavigationMode.cell,
                controller: _fgCtrl,
                // onSelectionChanging: (addedRows, removedRows) {
                // },
                onSelectionChanging:
                    (List<DataGridRow> src, List<DataGridRow> dsc) {
                  // //_fgCtrl.selectedIndex = detail.rowColumnIndex.rowIndex - 1;
                  // print("oncellTap src ${src.length}|dsc=${dsc.length}");
                  for (var row in src) {
                    print(
                        "oncellTap|src ${row.getCells()[0].columnName}|${row.getCells()[0].value}");
                    var cell = row.getCells()[0];
                    var key =
                        '${cell.columnName}:${(cell.value as String).split("(")[0]}';
                    if (facetsFilter.keys.contains(key)) {
                      facetsFilter.remove(key);
                    } else {
                      facetsFilter[key] = true;
                    }
                  }
                  for (var row in dsc) {
                    var cell = row.getCells()[0];
                    var key =
                        '${cell.columnName}:${(cell.value as String).split("(")[0]}';
                    print("oncellTap|src $key");
                    facetsFilter.remove(key);
                  }
                  hasQueryChanged = true;
                  _execSearchQuery();
                  return true;
                },
                columns: [
                  UIHelper.buildGridColumnFacets(label: item, columnName: item)
                ]),
          ));
      for (var fItem in facetsFilter.keys) {}
      sfgList.add(sf);
      facetDGctrls[item] = _fgCtrl;
    }
    return sfgList;
  }

  Widget _buildFacetWidgets() {
    var fr = result!.facetResult!;
    var gKeys = fr.keys.toList();
    print("gkeys $gKeys");
    List<Container> facetConList = [];

    var con = Container(
      constraints: BoxConstraints(maxWidth: 250, maxHeight: 300),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: ListView.builder(
          shrinkWrap: true,
          //physics: NeverScrollableScrollPhysics(),
          itemCount: fr.keys.length,
          itemBuilder: (BuildContext context, int index) {
            var terms = fr[gKeys[index]];
            return Column(
              children: _buildTerms(terms!),
            );
          }),
    );
    facetConList.add(con);
    return Column(children: facetConList);
  }

  Row _buildQueryCtrls() {
    //if (kDebugMode) {
    print("sinceAgoSelection $sinceAgoSelection");
    //}
    return Row(children: [
      Expanded(
        child: Padding(
          padding: AppValues.formFieldPadding,
          child: TextField(
            controller: pgIndexCtrl,
            // keyboardType: TextInputType.multiline,
            // textInputAction: TextInputAction.none,
            onChanged: (val) {
              hasQueryChanged = true;
            },
            onTap: () {
              if (hasQueryChanged) {
                _constructQueryFromCtrls();
              }
            },
            decoration: InputDecoration(
                labelText: "Page index [1-${_getMaxPagination()}]"),
            //readOnly: true,
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: AppValues.formFieldPadding,
          child: TextFormField(
            controller: pgSizeCtrl,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.none,
            decoration: InputDecoration(labelText: "Page size"),
            onChanged: (val) {
              hasQueryChanged = true;
            },
            onTap: () {
              if (hasQueryChanged) {
                _constructQueryFromCtrls();
              }
            },

            //readOnly: true,
          ),
        ),
      ),
      Expanded(
        child: SizedBox(
          width: 200,
          child: Padding(
            padding: AppValues.formFieldPadding,
            child: TextFormField(
              controller: totRecCtrl,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.none,
              readOnly: true,
              decoration: InputDecoration(labelText: "Total record"),
              //readOnly: true,
            ),
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: AppValues.formFieldPadding,
          child: TextFormField(
            controller: sinceOnCtrl,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.none,
            onChanged: (val) {
              hasQueryChanged = true;
            },
            onTap: () {
              if (hasQueryChanged) {
                _constructQueryFromCtrls();
              }
            },

            decoration: InputDecoration(labelText: "since On"),
            //readOnly: true,
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: AppValues.formFieldPadding,
          child: TextFormField(
            controller: sincetimeCtrl,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.none,
            onChanged: (val) {
              hasQueryChanged = true;
            },
            onTap: () {
              if (hasQueryChanged) {
                _constructQueryFromCtrls();
              }
            },

            decoration: InputDecoration(labelText: "since time"),
            //readOnly: true,
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: AppValues.formFieldPadding,
          child: CommonDropDown(
              k: "sinceAgo",
              w: 200,
              uniqueValues: sinceAgoDD.values.toList(),
              ddDataSourceNames: sinceAgoDD.values.toList(),
              lblTxt: "Since ago",
              selectedVal: sinceAgoSelection,
              onChanged: (String? val) {
                if (val != null) {
                  sinceAgoSelection = val;
                  hasQueryChanged = true;
                  //_constructQueryFromCtrls();

                }
              }),
        ),
      ),
    ]);
  }

  List<GridColumn> get _buildGirdColumn {
    var columns = <GridColumn>[];
    for (var item in result!.fields!) {
      columns.add(UIHelper.buildGridColumn(label: item, columnName: item));
    }
    return columns.toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }
}
