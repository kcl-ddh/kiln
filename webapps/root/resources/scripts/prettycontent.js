/*
* Licensed to the Apache Software Foundation (ASF) under one or more
* contributor license agreements.  See the NOTICE file distributed with
* this work for additional information regarding copyright ownership.
* The ASF licenses this file to You under the Apache License, Version 2.0
* (the "License"); you may not use this file except in compliance with
* the License.  You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
function xml2htmlToggle(event) {

    var mark;
    if (event.srcElement) {
      mark = event.srcElement;
    } else {
      mark = event.target;
    }

    while ((mark.className != "b") && (mark.nodeName != "BODY")) {
        mark = mark.parentNode
    }

    var e = mark;

    while ((e.className != "e") && (e.nodeName != "BODY")) {
        e = e.parentNode
    }

    if (mark.childNodes[0].nodeValue == "+") {
        mark.childNodes[0].nodeValue = "-";
        var starthiding = false;
        for (var i = 0; i < e.childNodes.length; i++) {
            var name = e.childNodes[i].nodeName;
            if (name != "#text") {
              if (starthiding) {
                if (name == "PRE" || name == "SPAN") {
                  window.status = "inline";
                  e.childNodes[i].style.display = "inline";
                } else {
                  e.childNodes[i].style.display = "block";
                }
              } else {
                 starthiding = true;
              }
            }
        }
    } else if (mark.childNodes[0].nodeValue == "-") {
        mark.childNodes[0].nodeValue = "+";
        var starthiding = false;
        for (var i = 0; i < e.childNodes.length; i++) {
            if (e.childNodes[i].nodeName != "#text") {
                if (starthiding) {
                    e.childNodes[i].style.display = "none";
                } else {
                    starthiding = true;
                }
            }
        }
    }
} 
