//Auto code generated from xml definition 2022-03-25 16:36:18.397158 -0400 EDT
//Search
import 'dart:math';

import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/modules/indexes/indexes.repo.dart';
import 'package:ez_search_ui/modules/search/queryHelperInfo.dart';
import 'package:ez_search_ui/modules/search/search.notifiers.dart';
import 'package:ez_search_ui/modules/theme/configtheme.dart';
import 'package:ez_search_ui/modules/theme/themenotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_search_ui/modules/search/facet.ds.dart';
import 'package:ez_search_ui/modules/search/search.ds.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:ez_search_ui/common/base_cubit.dart';
import 'package:ez_search_ui/common/global.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/helper/UIHelper.dart';
import 'package:ez_search_ui/helper/commondropdown.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.cubit.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.model.dart';
import 'package:ez_search_ui/modules/search/SearchResult.dart';
import 'package:ez_search_ui/modules/search/search.cubit.dart';
import 'package:ez_search_ui/modules/search/search.repo.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:universal_html/html.dart' as html;
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:provider/provider.dart';

import 'search.stateless.widgets.dart';

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
Map<String, IndexSchemaModel> curSchemas = {};
Map<String, DataGridController> facetDGctrls = {};

class _SearchPageState extends State<SearchPage> {
  late bool isWebOrDesktop;
  final DataGridController _dgController = DataGridController();
  final TextEditingController qTxtCtrl = TextEditingController();
  final TextEditingController nqNameCtrl = TextEditingController();
  final TextEditingController pgIndexCtrl = TextEditingController();
  final TextEditingController searchWordCtrl = TextEditingController();
  final TextEditingController pgSizeCtrl = TextEditingController();
  final TextEditingController sincetimeCtrl = TextEditingController();
  final TextEditingController sinceOnCtrl = TextEditingController();
  //final TextEditingController totRecCtrl = TextEditingController();
  final Notifier<int> totalRecords = Notifier<int>(0);
  ValueNotifier<String> queryNotifier = ValueNotifier<String>('');
  bool hasQueryChanged = false;

  // final Map<String, String> sinceAgoDD = {
  //   "1": "seconds",
  //   "2": "minutes",
  //   "3": "hours",
  //   "4": "days"
  // };
  final SinceAgoNotifier sinceAgoDDVal = SinceAgoNotifier();
  //final TextEditingController pgIndexCtrl = TextEditingController();

  final fn = FocusNode();
  final gfn = FocusNode();
  final nqfn = FocusNode();
  bool isQueryModifiedByUser = false;
  bool enablePagerLoad = true;
  var regEx = RegExp("select |from |where |limit |since |facets |sort ");

  /// Determine to decide whether the device in landscape or in portrait.
  late bool isLandscapeInMobileView;
  late double pageMaxheight;
  bool hassaveQueryChanged = false;

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

    pgSizeCtrl.text = "25";

    super.initState();
  }

  Map<String, String> _parseQuery() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      qTxtCtrl.text = curRptQuery.CustomData.trim();
    });
    //qTxtCtrl.text.trim();
    queryNotifier.value = curRptQuery.CustomData.trim();

    print(qTxtCtrl.text);
    var grps = regEx.allMatches(qTxtCtrl.text.toLowerCase());
    var curIdx = 0;
    var curKey = '';
    var maxLen = qTxtCtrl.text.length;
    // print("for grps maxlen $maxLen");
    Map<String, String> map = <String, String>{};
    RegExpMatch? item;
    for (item in grps) {
      if (curIdx > 0) {
        var nt = qTxtCtrl.text.substring(curIdx, item.start).trim();
        // print(
        //   "for grps if ${item.start},${item.end}[${curKey.substring(0, 3)}]=$nt");
        map[curKey.substring(0, 3).toLowerCase()] = nt;
      }
      curKey = qTxtCtrl.text.substring(item.start, item.end);
      curIdx = item.end;
      // print("for grps  ${item.start} ${item.end}");
    }
    //print("regex map grp ${map.keys} ${map.values}");
    item = grps.last;
    //print(
    //   "for grps out side grps $curIdx $maxLen, ${maxLen - item.end},start=${item.start},end=${item.end}, ${(curIdx < maxLen)}");
    if (curIdx < maxLen) {
      curKey = qTxtCtrl.text.substring(item.start, item.end);
      // print("for grps $curKey");
      var nt = qTxtCtrl.text.substring(item.end);
      //  print("for grps out side grps ${item.start} ${item.end} $nt");

      map[curKey.substring(0, 3).toLowerCase()] = nt;
      //qTxtCtrl.text.substring(item.end, maxLen - item.end).trim();
    }
    //print("regex map grp ${map.keys} ${map.values}");

    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      pageMaxheight = constraints.maxHeight;
      print(
          "Boxconstraint ${constraints.maxHeight}, w= ${constraints.maxWidth}");
      return Column(
        children: [
          Row(children: [
            _rptDropDownBlocBuilder(),
            Expanded(child: _buildqueryEditTb()),
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  _showQueryInfoDialog();
                },
                icon: Icon(Icons.info_rounded)),
            TextButton(
                onPressed: () async {
                  if (qTxtCtrl.text.isNotEmpty) {
                    _execSearchQuery();
                  } else {
                    _showSnackBarMessage("Please select a query defintion.");
                  }
                },
                child: Text("Run")),
            SizedBox(
              width: 30,
              child: BlocBuilder<RptQuerySaveCubit, RptQueryState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (qTxtCtrl.text.isNotEmpty) {
                              _saveRptQuery();
                              _showSnackBarMessage("saved successfully");
                            } else {
                              _showSnackBarMessage(
                                  "Please select a query defintion.");
                            }
                          },
                          icon: Icon(Icons.save_outlined),
                          tooltip: "Save"),
                      if (state is RptQueryLoading) CircularProgressIndicator(),
                      if (state is RptQueryFailure) Text(state.errorMsg),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              width: 30,
              child: BlocBuilder<RptQuerySaveCubit, RptQueryState>(
                  builder: (context, state) {
                return Column(
                  children: [
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (qTxtCtrl.text.isNotEmpty) {
                            _showSaveDialog();
                          } else {
                            _showSnackBarMessage(
                                "Please select a query defintion.");
                          }
                        },
                        icon: Icon(Icons.save_as_outlined),
                        tooltip: "Save as"),
                    if (state is BaseLoading) CircularProgressIndicator(),
                    if (state is RptQueryFailure) Text(state.errorMsg),
                  ],
                );
              }),
            ),
            SizedBox(
              width: 30,
              child: BlocBuilder<RptQuerySaveCubit, RptQueryState>(
                  builder: (context, state) {
                return Column(
                  children: [
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (qTxtCtrl.text.isNotEmpty) {
                            exportToCsvDialog();
                          } else {
                            _showSnackBarMessage(
                                "Please select a query defintion.");
                          }
                        },
                        icon: const Icon(Icons.download_rounded),
                        tooltip: "Csv Download"),
                    if (state is BaseLoading) CircularProgressIndicator(),
                    if (state is RptQueryFailure) Text(state.errorMsg),
                  ],
                );
              }),
            ),
          ]),
          _buildQueryCtrls(),
          _sfGridBuildBlocBuilder(),
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
    //final DateFormat format = DateFormat("yyy-MM-dd-hh-mm-ss");
    final String formated = DateTime.now().toString();
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

  Widget _buildqueryEditTb() {
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
            // if (isQueryModifiedByUser) {
            //   curRptQuery.CustomData = qTxtCtrl.text;
            //   isQueryModifiedByUser = false;
            // }

            //isQueryModifiedByUser = false;
            //_execSearchQuery();
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
    return ValueListenableBuilder<String>(
        valueListenable: queryNotifier,
        builder: (context, value, child) {
          qTxtCtrl.text = value;
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
                  // if (isQueryModifiedByUser) {
                  //   curRptQuery.CustomData = qTxtCtrl.text;
                  //   isQueryModifiedByUser = false;
                  // }

                  //isQueryModifiedByUser = false;
                  //_execSearchQuery();
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
        });
  }

  void _execSearchQuery() {
    //print("_execSearchQuery() ${curRptQuery.CustomData} ${qTxtCtrl.text}");
    // if (isQueryModifiedByUser) {
    //   curRptQuery.CustomData = qTxtCtrl.text;
    //   isQueryModifiedByUser = false;
    // }
    //if (hasQueryChanged)

    _constructQueryFromCtrls();

    print("Executesearchquery|#369 ${qTxtCtrl.text}");
    //_constructQueryFromCtrls();

    BlocProvider.of<SearchCubit>(context).getAllSearchs(qTxtCtrl.text);
  }

  void _showQueryInfoDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Query Helper'),
              content: SingleChildScrollView(
                child: InfoHelper.queryInfoText(context),
              ));
        });
  }

  void _showSaveDialog() {
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
          // print("on key%${nqNameCtrl.text}");
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
      //print("rptName loop $item");
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
          division: "",
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
    // qTxtCtrl.text = curRptQuery.CustomData;
    print("starting func  $qParsedMap");
    var sb = StringBuffer();
    if (qParsedMap["sel"] != null) {
      sb.write('select ${qParsedMap["sel"]} ');
    }
    if (qParsedMap["fro"] != null) {
      sb.write('from ${qParsedMap["fro"]} ');
    }
    print("after where $qParsedMap");
    var wClause = qParsedMap["whe"];
    var commaChar = ',';
    if (wClause == null) {
      wClause = '';
      commaChar = '';
    }

    var facetKeys = '';
    print("facetsFilter.keys ${facetsFilter.keys}");
    if (facetsFilter.keys.isNotEmpty) {
      facetKeys = facetsFilter.keys.join(",+");
      if (!wClause.contains(facetKeys)) {
        print("(!wClause.contains(facetKeys) ${wClause}");
        wClause = '$wClause$commaChar +$facetKeys';
        commaChar = ',';
      }
    }

    if (searchWordCtrl.text.isNotEmpty) {
      if (!wClause.contains(searchWordCtrl.text)) {
        wClause = '$wClause$commaChar ${searchWordCtrl.text}';
      }
    }
    if (wClause.length > 0) {
      sb.write('where $wClause ');
    }
    print("after where $qParsedMap ${sinceAgoDDVal.selectedVal}");
    if (sinceOnCtrl.text.isNotEmpty) {
      sb.write(
          "since ${sinceOnCtrl.text}:${sincetimeCtrl.text} ${sinceAgoDDVal.selectedVal} ago ");
    }
    if (qParsedMap["sor"] != null) {
      sb.write("sort ${qParsedMap["sor"]} ");
    }
    // if (qParsedMap["lim"] != null) {
    //print("start idnex ${pgIndexCtrl.text}");
    if (pgIndexCtrl.text.isNotEmpty) {
      sb.write("limit ${_getStartIndex()},${pgSizeCtrl.text} ");
    }
    if (qParsedMap["fac"] != null) {
      sb.write("facets ${qParsedMap["fac"]} ");
    }
    // print("finalquery${sb.toString().trim()}");

    qTxtCtrl.text = sb.toString().trim();
    queryNotifier.value = qTxtCtrl.text;
    print("Executesearchquery|${qTxtCtrl.text}");

    // setState(() {});
  }

  void _updateCtrlsFromQuery() {
    print("_updateCtrlsFromQuery");

    qParsedMap = _parseQuery();
    // print("after query parsed $qParsedMap");
    if (qParsedMap["lim"] != null) {
      var lim = qParsedMap["lim"];
      var splits = lim?.split(",");
      if (splits!.isNotEmpty) pgSizeCtrl.text = splits[1];
    }
    print("after limt $qParsedMap");
    if (qParsedMap["sin"] != null) {
      List<String> clause = (qParsedMap['sin'] ?? '').split(" ");
      // print("since clause ${clause.length} ${clause[0]} ${clause[1]}");
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
      Future.delayed(Duration.zero, () {
        sinceAgoDDVal.selectedVal = clause[1];
      });

      // for (var item in sinceAgoDD.values) {
      //   //print("since ago| ${clause[1]}| $item");
      //   if (item == clause[1]) {
      //     sinceAgoDDVal.value = item;
      //     break;
      //   }
      // }
    }
    print("after end fun $qParsedMap");
    hasQueryChanged = false;
    isQueryModifiedByUser = false;
    //setState(() {});
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
              height: 45,
              width: 45,
              child: Center(
                  child: const CircularProgressIndicator(
                strokeWidth: 4,
              )));
        } else if (state is SearchFailure) {
          return Center(
            child: Text(state.errorMsg),
          );
        } else if (state is SearchSuccess) {
          result = state.props;
          _updateCtrlsFromQuery();
          Future.delayed(Duration.zero, () {
            totalRecords.value = result == null ? 0 : result!.total;
          });

          // setState(() {});
          //print("_updateCtrlsFromQuery|672");
          return _buildSearchGrid();
        } else if (state is SearchEmpty) {
          return const Text(AppValues.noRecFoundExpLbl);
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
                w: Global.isDesktop ? 400 : 150,
                uniqueValues: rptList.map((e) => e.id).toList(),
                lblTxt: "Query defition",
                onChanged: (String? val) async {
                  facetsFilter.clear();
                  if (val != null) {
                    for (var item in rptList) {
                      if (item.id == val) {
                        curRptQuery = item;
                        qTxtCtrl.text = item.CustomData;
                        searchWordCtrl.text = '';
                        _updateCtrlsFromQuery();
                        // Future.delayed(Duration.zero, () {
                        //   totalRecords.value = 0;
                        // });
                        // print(
                        //     "getSchema|before repo call ${qParsedMap['fro']} $curSchemas ");
                        IndexRepo repo = IndexRepo();
                        var list = await repo.getSchema(
                            ApiPaths.getIndexSchema, qParsedMap['fro']);
                        curSchemas = {};
                        for (var i in list) {
                          curSchemas[i.name] = i;
                        }
                        // print(
                        //     "getSchema|cur schema ${qParsedMap['fro']} $curSchemas ");
                        facetsFilter.clear();
                        fn.requestFocus();
                        BlocProvider.of<SearchCubit>(context).clearResultGrid();
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
    //TODO.. refactor while clicking Run button.
    // if (result != null) {
    //   maxCount =
    //       (result!.total / int.parse(pgSizeCtrl.text)).floorToDouble().toInt();
    // }
    // print(
    //     "Executesearchquery|result!.total=${result!.total} / ${pgSizeCtrl.text}");
    return maxCount;
  }

  Widget _buildSearchGrid() {
    var fr = result!.facetResult!;

    // print(
    //    "result!.facetResult != null ${result!.facetResult != null}, firstkey:${fr.keys.first.length}, ${fr.values.length}, isempty ${fr.isEmpty} fr:${result!.facetResult!}, len ${result!.facetResult!.length}, ${fr.keys.length}");

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result!.facetResult!.keys.first.isNotEmpty)
            Container(
              height:
                  Global.isDesktop ? pageMaxheight - 180 : pageMaxheight - 200,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: _buildSFGridForFacet(),
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
              ),
            ),
          Expanded(
            child: Column(children: [
              //_buildQueryCtrls(),
              Padding(
                padding: EdgeInsets.all(AppValues.sfGridPadding),
                child: Container(
                  height: Global.isDesktop
                      ? pageMaxheight - 180
                      : pageMaxheight - 200,
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(
                        headerColor: ezThemeData[ThemeNotifier.ezCurThemeName]
                            ?.focusColor),
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
                ),
              ),
            ]),
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
    //print("serchpage|817, $fr");
    var gKeys = fr.keys.toList();
    // print("serchpage|817, $gKeys");
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
      //print("serchpage|845");
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
        width: Global.isDesktop ? 400 : 200,
        //height: 60 + srcItems.rows.length * 30,
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                top: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black))),
        child: SfDataGrid(
            //allowSorting: true,

            //isScrollbarAlwaysShown: true,
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
                // print("oncellTap|src $key");
                facetsFilter.remove(key);
              }
              hasQueryChanged = true;
              _execSearchQuery();
              return true;
            },
            columns: [
              UIHelper.buildGridColumnFacets(label: item, columnName: item)
            ]),
      );
      for (var fItem in facetsFilter.keys) {}
      sfgList.add(sf);
      facetDGctrls[item] = _fgCtrl;
    }
    return sfgList;
  }

  Widget _buildFacetWidgets() {
    var fr = result!.facetResult!;
    var gKeys = fr.keys.toList();
    // print("gkeys $gKeys");
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

  Widget _buildQueryCtrls() {
    //if (kDebugMode) {
    // print("sinceAgoSelection $sinceAgoSelection");
    //}
    return Row(children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: TextField(
            controller: searchWordCtrl,
            // keyboardType: TextInputType.multiline,
            // textInputAction: TextInputAction.none,
            onChanged: (val) {
              hasQueryChanged = true;
              isQueryModifiedByUser = true;
            },
            // onTap: () {
            //   if (hasQueryChanged) {
            //     _constructQueryFromCtrls();
            //   }
            // },
            decoration: const InputDecoration(labelText: "Search term"),
            //readOnly: true,
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(4),
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
          padding: const EdgeInsets.all(4),
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
        child: ChangeNotifierProvider.value(
          value: totalRecords,
          child: SearchTotRecordsWidget(),
        ),
      )),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(4),
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
          padding: const EdgeInsets.all(4),
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
            padding: const EdgeInsets.all(4),
            child: ChangeNotifierProvider.value(
              value: sinceAgoDDVal,
              child: SinceAgoDropdownWidget(),
            )),
      ),
    ]);
  }

  List<GridColumn> get _buildGirdColumn {
    var columns = <GridColumn>[];
    // ignore: curly_braces_in_flow_control_structures
    // print('curSchemas');
    // print(curSchemas);
    // print("result!.fields!"); // print("_buildGirdCol ${result!.fields!}");

    // print(result!.fields!);
    for (var colName in result!.fields!) {
      // String? lbl = item;\

      var fieldName = curSchemas[colName];
      String label = fieldName != null
          ? (fieldName.dn.isNotEmpty ? "${fieldName.dn}|$colName" : colName)
          : colName;
      if (label.isEmpty) {
        label = colName;
      }
      columns.add(UIHelper.buildGridColumn(label: label, columnName: colName));
    }

    print(columns.toList().length);
    return columns.toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }
}
