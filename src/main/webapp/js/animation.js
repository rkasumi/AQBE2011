var initDelete, initInline, loadEvent;
var __indexOf = Array.prototype.indexOf || function(item) {
  for (var i = 0, l = this.length; i < l; i++) {
    if (this[i] === item) return i;
  }
  return -1;
};
$(function() {
  loadEvent();
  return initInline();
});
loadEvent = function() {
  var conditionCount;
  $("#selectConcept").change(function() {
    var val;
    if ($("[name=selectConceptForm]").val() === "") {
      val = $(this).val();
    } else {
      val = $("[name=selectConceptForm]").val() + "," + $(this).val();
    }
    return $("[name=selectConceptForm]").val(val);
  });
  $("[name=selectConceptSubmit]").click(function() {
    $("#xml").hide(100);
    $("#aqbe").hide(100);
    $("#concept").hide(100);
    $("#condition").hide(100);
    $("#showAql").hide(100);
    $("#loading").slideDown(100);
    return $("form").submit();
  });
  $("#selectEHR").click(function() {
    $("[name=selectedConcept]").val("e");
    $("#aqbe").slideUp(100);
    $(".aqbe_table").hide();
    $("#ehr").show();
    $("#aqbe").slideDown(300);
    return $("#condition").hide(300);
  });
  $("#selectComposition").click(function() {
    var i, num, select, selectedJoin, selectedValue, val;
    i = 0;
    num = 0;
    val = $(this).val();
    $("#selectComposition option, #selectComposition option").each(function() {
      if ($(this).val() === val) {
        num = i;
      }
      return i++;
    });
    $("[name=selectedConcept]").val("c" + num);
    selectedValue = $(this).children(":selected").attr("name");
    selectedJoin = $(this).children(":selected").attr("join");
    if (selectedValue.indexOf("COMPOSITION") !== -1) {
      select = "COMPOSITION";
    }
    if ($("#fromConcept").val() === "") {
      $("#fromConcept").val("" + selectedJoin + "," + select + " c" + num + "[" + selectedValue + "]");
    } else if ($("#fromConcept").val().indexOf(selectedValue) === -1) {
      $("#fromConcept").val($("#fromConcept").val() + ("|" + selectedJoin + "," + select + " c" + num + "[" + selectedValue + "]"));
    }
    $("#aqbe").slideUp(100);
    $(".aqbe_table").hide();
    $("#" + ($(this).val())).show();
    $("#aqbe").slideDown(300);
    return $("#condition").hide(300);
  });
  $("#selectEntry").click(function() {
    var i, join, num, select, selectedValue, val;
    i = 0;
    num = 0;
    val = $(this).val();
    $("#selectComposition option, #selectEntry option").each(function() {
      if ($(this).val() === val) {
        num = i;
      }
      return i++;
    });
    $("[name=selectedConcept]").val("c" + num);
    selectedValue = $(this).children(":selected").attr("name");
    join = $(this).children(":selected").attr("join");
    if (selectedValue.indexOf("OBSERVATION") !== -1) {
      select = "OBSERVATION";
    }
    if (selectedValue.indexOf("SECTION") !== -1) {
      select = "SECTION";
    }
    if (selectedValue.indexOf("ITEM_TREE") !== -1) {
      select = "ITEM_TREE";
    }
    if (selectedValue.indexOf("EVALUATION") !== -1) {
      select = "EVALUATION";
    }
    if (selectedValue.indexOf("INSTRUCTION") !== -1) {
      select = "INSTRUCTION";
    }
    if (selectedValue.indexOf("ACTION") !== -1) {
      select = "ACTION";
    }
    if (selectedValue.indexOf("ADMIN_ENTRY") !== -1) {
      select = "ADMIN_ENTRY";
    }
    if ($("#fromConcept").val() === "") {
      $("#fromConcept").val("" + join + "," + select + " c" + num + "[" + selectedValue + "]");
    } else if ($("#fromConcept").val().indexOf(selectedValue) === -1) {
      $("#fromConcept").val($("#fromConcept").val() + ("|" + join + "," + select + " c" + num + "[" + selectedValue + "]"));
    }
    $("#selectComposition option").each(function() {
      var name;
      if ($(this).attr("join") === join) {
        val = $(this).val();
        i = 0;
        $("#selectComposition option, #selectEntry option").each(function() {
          if ($(this).val() === val) {
            num = i;
          }
          return i++;
        });
        name = $(this).attr("name");
        if ($("#fromConcept").val() === "") {
          return $("#fromConcept").val("COMPOSITION c" + num + "[" + name + "]");
        } else if ($("#fromConcept").val().indexOf(name) === -1) {
          return $("#fromConcept").val($("#fromConcept").val() + ("|" + join + ",COMPOSITION c" + num + "[" + name + "]"));
        }
      }
    });
    $("#aqbe").slideUp(100);
    $(".aqbe_table").hide();
    $("#" + ($(this).val())).show();
    $("#aqbe").slideDown(300);
    return $("#condition").hide(300);
  });
  $(".input_condition").click(function() {
    var obj, objF;
    obj = $("." + $(this).attr("name"));
    objF = $("." + $(this).attr("name") + "func");
    if (obj.is(":hidden")) {
      obj.slideDown(200);
      objF.hide();
      $(this).val("Close Condition");
      return $(this).next().val("Input Function");
    } else {
      obj.slideUp(200);
      return $(this).val("Input Condition");
    }
  });
  $(".input_function").click(function() {
    var obj, objC;
    obj = $("." + $(this).attr("name") + "func");
    objC = $("." + $(this).attr("name"));
    if (obj.is(":hidden")) {
      obj.slideDown(200);
      objC.hide();
      $(this).val("Close Function");
      return $(this).prev().val("Input Condition");
    } else {
      obj.slideUp(200);
      return $(this).val("Input Function");
    }
  });
  $(".dv_quantity_unit").change(function() {
    var hash, max, min;
    hash = $(this).attr("name");
    min = $(this).children(":selected").attr("min");
    max = $(this).children(":selected").attr("max");
    if (min == null) {
      min = "-2147483648";
    }
    if (max == null) {
      max = "2147483647";
    }
    $("[name=" + hash + "][min]").attr({
      "min": min
    });
    return $("[name=" + hash + "][max]").attr({
      "max": max
    });
  });
  $(".sendConditionBox").click(function() {
    var checkFlag, cnt, con, conditionBox, i, key, name, num, param, path, tag, temp, type, val, value, _ref;
    param = {};
    i = 0;
    $("[name=" + ($(this).attr("name")) + "] .value").each(function() {
      return param[i++] = $(this).val();
    });
    if (i !== 0) {
      if ($("#sendCount").val() !== "0") {
        temp = "<select class=\"operation\">" + "<option value=\"AND\">AND</option>" + "<option value=\"OR\">OR</option>" + "</select>";
        $("#condition").append(temp);
      }
      $("#sendCount").val("1");
      num = 0;
      for (key in param) {
        value = param[key];
        num++;
      }
      cnt = 1;
      for (key in param) {
        value = param[key];
        _ref = value.split("|"), type = _ref[0], name = _ref[1], path = _ref[2], con = _ref[3], val = _ref[4];
        conditionBox = new ConditionBox(type, name, path, con, val);
        $("#condition").append(conditionBox.toHtml(num, cnt++));
        $("#condition").append(conditionBox.operation());
      }
      $($(".operation")[$(".operation").length - 1]).remove();
      tag = "<input type=\"button\" class=\"orderButoon\" value=\"update order\" />";
      $("#condition").append(tag);
      loadEvent();
    }
    checkFlag = 0;
    $(".checkbox").each(function() {
      var t;
      if ($(this).is(":checked") === true) {
        if ($(this).attr("name") === "*") {
          checkFlag = 1;
          t = "<input type=\"hidden\" class=\"checkedBox\" value=\"" + ($("[name=selectedConcept]").val()) + "\" />";
          $("#condition").append(t);
        }
        if (checkFlag !== 1) {
          t = "<input type=\"hidden\" class=\"checkedBox\" value=\"" + ($("[name=selectedConcept]").val()) + ($(this).attr("name")) + "\" />";
          return $("#condition").append(t);
        }
      }
    });
    $(".functionalSelect").each(function() {
      var t;
      t = "<input type=\"hidden\" class=\"checkedBox\" value=\"" + ($(this).val()) + "\" />";
      return $("#condition").append(t);
    });
    $(".object").each(function() {
      return $(this).remove();
    });
    $("#aqbe").hide(300);
    $("#showAql").hide(300);
    return $("#condition").slideDown(300);
  });
  conditionCount = 0;
  $(".function").change(function() {
    var baseUrl, hash, key, name, param, path, tag, value;
    hash = $(this).attr("name");
    $("[func=func" + hash + "]").children().each(function() {
      return $(this).remove();
    });
    switch ($(this).val()) {
      case "rename":
        param = {};
        $("[name=" + hash + "]").each(function() {
          return param[$(this).attr("class")] = $(this).val();
        });
        for (key in param) {
          value = param[key];
          switch (key) {
            case "name":
              name = value;
              break;
            case "path":
              path = $("[name=selectedConcept]").val() + value;
          }
        }
        tag = "<input type=\"text\" class=\"" + hash + "_rename\" name=\"" + path + "\" value=\"\" placeholder=\"" + name + "\" />";
        return $(this).next().append(tag);
      case "devide":
        param = {};
        $("[name=" + hash + "]").each(function() {
          return param[$(this).attr("class")] = $(this).val();
        });
        for (key in param) {
          value = param[key];
          switch (key) {
            case "name":
              name = value;
              break;
            case "path":
              path = $("[name=selectedConcept]").val() + value;
          }
        }
        tag = "<span>" + name + " / </span>";
        tag += "<select class=\"" + hash + "_devide\" name=\"" + path + "\">";
        $(".forDevide").each(function() {
          return tag += "<option value=\"" + ($(this).val()) + "\">" + ($(this).attr("name")) + "</option>";
        });
        tag += "</select>";
        tag += "<select class=\"" + hash + "_devide_condition\">";
        tag += "<option value=\"eq\">=</option>";
        tag += "<option value=\"not\">!=</option>";
        tag += "<option value=\"big\">&lt;</option>";
        tag += "<option value=\"small\">&gt;</option>";
        tag += "<option value=\"bigeq\">&lt;=</option>";
        tag += "<option value=\"smalleq\">&gt;=</option>";
        tag += "</select>";
        tag += "<input type=\"number\" class=\"" + hash + "_devide_value\" value=\"0.0\" step=\"0.01\" />";
        return $(this).next().append(tag);
      case "in":
      case "notin":
      case "equals":
        param = {};
        $("[name=" + hash + "]").each(function() {
          return param[$(this).attr("class")] = $(this).val();
        });
        for (key in param) {
          value = param[key];
          switch (key) {
            case "name":
              name = value;
              break;
            case "path":
              path = $("[name=selectedConcept]").val() + value;
          }
        }
        tag = "<span>" + name + " " + ($(this).val()) + " [object]</span>";
        tag += "<input type=\"hidden\" class=\"" + hash + "_" + ($(this).val()) + "\" name=\"" + name + "\" path=\"" + path + "\" value=\"\" />";
        $(this).next().append(tag);
        $("#content").hide(500);
        baseUrl = $("h1 a").attr("href");
        $("#inline iframe").attr("src", "" + baseUrl + "?inlineField=" + hash + "_" + ($(this).val()));
        return $("#inline").slideDown(500);
    }
  });
  $(".inputfunction").click(function() {
    var con, con2, cons2, funcValue, hash, key, name, number, param, path, tag, tempCon, tempName, tempPath, tempVal, value;
    hash = $(this).attr("name");
    param = {};
    $("[name=" + hash + "]").each(function() {
      return param[$(this).attr("class")] = $(this).val();
    });
    for (key in param) {
      value = param[key];
      switch (key) {
        case "name":
          name = value;
          break;
        case "path":
          path = $("[name=selectedConcept]").val() + value;
      }
    }
    number = "" + hash + "_num" + (conditionCount++);
    funcValue = $("." + hash + "func .function").val();
    switch (funcValue) {
      case "exists":
        tag = "<div class=\"object\" name=\"" + number + "\">";
        tag += "<input type=\"button\" value=\"x\" class=\"delete\" name=\"" + number + "\" /> ";
        tag += "exists";
        tag += "<input class=\"value\" type=\"hidden\" value=\"exists|" + name + "|" + path + "||\" />";
        tag += "</div>";
        break;
      case "count":
        tag = "<div class=\"object\" name=\"" + number + "\">";
        tag += "<input type=\"button\" value=\"x\" class=\"delete\" name=\"" + number + "\" /> ";
        tag += "count";
        tag += "<input class=\"functionalSelect\" type=\"hidden\" value=\"COUNT(" + path + ")\" />";
        tag += "</div>";
        break;
      case "rename":
        tag = "<div class=\"object\" name=\"" + number + "\">";
        tag += "<input type=\"button\" value=\"x\" class=\"delete\" name=\"" + number + "\" /> ";
        tag += "rename " + ($("." + hash + "_rename").val());
        tag += "<input class=\"functionalSelect\" type=\"hidden\" value=\"" + path + " AS '" + ($("." + hash + "_rename").val()) + "'\" />";
        tag += "</div>";
        break;
      case "devide":
        tempName = name + " / " + $("." + hash + "_devide option:selected").text();
        tempPath = "(" + path + "/magnitude / " + $("[name=selectedConcept]").val() + $("." + hash + "_devide").val() + "/magnitude)";
        tempCon = $("." + hash + "_devide_condition option:selected").val();
        switch (tempCon) {
          case "eq":
            con = "=";
            con2 = "=";
            break;
          case "not":
            con = "!=";
            con2 = "!=";
            break;
          case "big":
            con = "&lt;";
            con2 = "%big%";
            break;
          case "small":
            con = "&gt;";
            con2 = "%small%";
            break;
          case "bigeq":
            con = "&lt;=";
            cons2 = "%big%=";
            break;
          case "smalleq":
            con = "&gt;=";
            con2 = "%small%=";
            break;
          default:
            con = "=";
        }
        tempVal = $("." + hash + "_devide_value").val();
        tag = "<div class=\"object\" name=\"" + number + "\">";
        tag += "<input type=\"button\" value=\"x\" class=\"delete\" name=\"" + number + "\" /> ";
        tag += "" + tempName + " " + con + " " + tempVal;
        tag += "<input class=\"value\" type=\"hidden\" value=\"devide|" + tempName + "|" + tempPath + "|" + con2 + "|" + tempVal + "\" />";
        tag += "</div>";
        break;
      case "in":
      case "notin":
      case "equals":
        tag = "<div class=\"object\" name=\"" + number + "\">";
        tag += "<input type=\"button\" value=\"x\" class=\"delete\" name=\"" + number + "\" /> ";
        tag += "" + name + " " + funcValue + " [object]";
        tag += "<input class=\"value\" type=\"hidden\" value=\"" + funcValue + "|" + name + "|" + path + "|" + funcValue + "|" + ($("." + hash + "_" + funcValue).val()) + "\" />";
        tag += "</div>";
    }
    $("." + hash + "show").append(tag);
    $("[name=" + number + "]").show();
    return initDelete();
  });
  $(".input").click(function() {
    var adl, condition, hash, key, name, number, param, path, value, valueList;
    hash = $(this).attr("name");
    param = {};
    $("[name=" + hash + "]").each(function() {
      return param[$(this).attr("class")] = $(this).val();
    });
    valueList = {};
    for (key in param) {
      value = param[key];
      switch (key) {
        case "input_condition":
        case "input_function":
        case "function":
        case "input":
        case "inputfunction":
        case "function":
          value;
          break;
        case "name":
          name = value;
          break;
        case "path":
          path = $("[name=selectedConcept]").val() + value;
          break;
        case "condition":
          condition = value;
          break;
        default:
          valueList[key] = value;
      }
    }
    number = "" + hash + "_num" + (conditionCount++);
    adl = new AdlAttribute(name, path, condition, valueList, number);
    $("." + hash + "show").append(adl.toHtml());
    $("[name=" + number + "]").show(100);
    return initDelete();
  });
  $("#generateAql").click(function() {
    var c, from, fromCount, fromKey, fromValue, i, j, k, key, selectFlag, tag, tagTemp, v, value, _i, _len, _ref, _ref2;
    tag = "SELECT \n";
    selectFlag = 0;
    $(".checkedBox").each(function() {
      selectFlag = 1;
      return tag += "\t" + ($(this).val()) + ",\n";
    });
    if (selectFlag === 1) {
      tag = tag.replace(/,\n$/, "\n");
    }
    if (selectFlag === 0) {
      tag += "\t*\n";
    }
    tag += "FROM\n";
    tag += "\tEHR e[ehr_id=$ehrId]\n";
    i = 0;
    from = {};
    _ref = $("#fromConcept").val().split("|");
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      v = _ref[_i];
      _ref2 = v.split(","), j = _ref2[0], k = _ref2[1];
      if (from["" + j] == null) {
        from["" + j] = "\t\t" + k + "\n";
      } else {
        from["" + j] += "\t\tCONTAINS " + k + "\n";
      }
    }
    fromCount = 0;
    for (fromKey in from) {
      fromValue = from[fromKey];
      fromCount++;
    }
    if (fromCount <= 1) {
      tag += "\tCONTAINS " + ("" + fromValue).replaceAll("\t\t", "\t").replace(/^\t/, "");
    } else {
      for (fromKey in from) {
        fromValue = from[fromKey];
        if (fromKey === "0") {
          tag += "\tCONTAINS (\n";
        }
        if (fromKey !== "0") {
          tag += "\tAND\n";
        }
        tag += "" + fromValue;
      }
      tag += "\t)\n";
    }
    tagTemp = "";
    v = {};
    c = {};
    i = 0;
    $(".conditionbox").each(function() {
      return v["" + (i++)] = $(this).val();
    });
    i = 0;
    $(".operation").each(function() {
      return c["" + (i++)] = $(this).val();
    });
    for (key in v) {
      value = v[key];
      tagTemp += "\t" + value;
      if (c[key] != null) {
        tagTemp += " " + c[key] + "\n";
      }
    }
    if (tagTemp !== "") {
      tag += "WHERE\n" + tagTemp;
    }
    $("#xml").hide(300);
    $("#condition").hide(300);
    if ($("[name=inlineField]").val() !== "") {
      $("#inlineArea").val(tag.replaceAll("\n", "%cr%").replaceAll("\t", "%tab%"));
      $(".inlineShow").show();
    }
    tag = tag.replaceAll("%big%", "<");
    tag = tag.replaceAll("%small%", ">");
    tag = tag.replaceAll("notin", "not in");
    tag = tag.replaceAll("%cr%", "\n");
    tag = tag.replaceAll("%tab%", "\t");
    $("#showAql textarea").val(tag);
    return $("#showAql").slideDown(300);
  });
  return $(".orderButoon").click(function() {
    var checkFlag, cnt, con, conditionBox, error, errorList, i, k, name, num, param, param2, path, tag, type, v, val, _ref, _ref2;
    i = 0;
    error = 0;
    errorList = [];
    $(".order").each(function() {
      var _ref;
      if (_ref = $(this).val(), __indexOf.call(errorList, _ref) >= 0) {
        error = 1;
      }
      return errorList += $(this).val();
    });
    if (error === 0) {
      param = {};
      param2 = {};
      num = 1;
      $(".forOrder").each(function() {
        return param[num++] = $(this).val();
      });
      num = 1;
      $(".order").each(function() {
        return param2[num++] = $(this).val();
      });
      $("#condition div").each(function() {
        return $(this).remove();
      });
      $("#condition .operation").each(function() {
        return $(this).remove();
      });
      $("#condition .orderButoon").each(function() {
        return $(this).remove();
      });
      cnt = 1;
      for (i = 1, _ref = num - 1; 1 <= _ref ? i <= _ref : i >= _ref; 1 <= _ref ? i++ : i--) {
        for (k in param2) {
          v = param2[k];
          if (("" + i) === ("" + v)) {
            _ref2 = param[k].split("|"), type = _ref2[0], name = _ref2[1], path = _ref2[2], con = _ref2[3], val = _ref2[4];
            conditionBox = new ConditionBox(type, name, path, con, val);
            $("#condition").append(conditionBox.toHtml(num - 1, cnt++));
            $("#condition").append(conditionBox.operation());
          }
        }
      }
      $($(".operation")[$(".operation").length - 1]).remove();
      tag = "<input type=\"button\" class=\"orderButoon\" value=\"update order\" />";
      $("#condition").append(tag);
      checkFlag = 0;
      $(".checkbox").each(function() {
        var t;
        if ($(this).is(":checked") === true) {
          if ($(this).attr("name") === "*") {
            checkFlag = 1;
            t = "<input type=\"hidden\" class=\"checkedBox\" value=\"" + ($("[name=selectedConcept]").val()) + "\" />";
            $("#condition").append(t);
          }
          if (checkFlag !== 1) {
            t = "<input type=\"hidden\" class=\"checkedBox\" value=\"" + ($("[name=selectedConcept]").val()) + ($(this).attr("name")) + "\" />";
            return $("#condition").append(t);
          }
        }
      });
      $(".functionalSelect").each(function() {
        var t;
        t = "<input type=\"hidden\" class=\"checkedBox\" value=\"" + ($(this).val()) + "\" />";
        return $("#condition").append(t);
      });
      $(".object").each(function() {
        return $(this).remove();
      });
      $("#aqbe").hide(300);
      $("#showAql").hide(300);
      $("#condition").slideDown(300);
      return loadEvent();
    }
  });
};
initDelete = function() {
  $(".delete").click(function() {
    var hash;
    hash = $(this).attr("name");
    return $("[name=" + hash + "]").hide(100, function() {
      return $("[name=" + hash + "]").remove();
    });
  });
};
initInline = function() {
  $("iframe").load(function() {
    $(this).height(this.contentWindow.document.documentElement.scrollHeight + 10);
    return $("iframe").triggerHandler("load");
  });
  return $("#inlineButton").click(function() {
    var inlineHash, result;
    inlineHash = $("[name=inlineField]").val();
    result = $("#inlineArea").val();
    $("." + inlineHash, window.parent.document).val(result);
    $("#content", window.parent.document).slideDown(500);
    return $("#inline", window.parent.document).slideUp(500);
  });
};
String.prototype.replaceAll = function(org, dest) {
  return this.split(org).join(dest);
};