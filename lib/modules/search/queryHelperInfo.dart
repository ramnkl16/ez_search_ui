import 'package:flutter/material.dart';

class InfoHelper {
  static RichText queryInfoText(BuildContext context) {
    return RichText(
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
    );
  }
}
