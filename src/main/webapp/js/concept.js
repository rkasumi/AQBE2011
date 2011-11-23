var AdlAttribute, ConditionBox;
AdlAttribute = (function() {
  function AdlAttribute(name, path, condition, valueList, hash) {
    this.name = name;
    this.path = path;
    this.condition = condition;
    this.valueList = valueList;
    this.hash = hash;
  }
  AdlAttribute.prototype.toHtml = function() {
    var con, con2, cons2, key, tag, value, _ref, _ref2;
    tag = "<div class=\"object\" name=\"" + this.hash + "\">";
    tag += "<input type=\"button\" value=\"x\" class=\"delete\" name=\"" + this.hash + "\" /> ";
    tag += "" + this.name + " ";
    switch (this.condition) {
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
    tag += " " + con + " ";
    _ref = this.valueList;
    for (key in _ref) {
      value = _ref[key];
      tag += "" + value + " ";
    }
    _ref2 = this.valueList;
    for (key in _ref2) {
      value = _ref2[key];
      tag += "<input type=\"hidden\" class=\"value\" value=\"" + key + "|" + this.name + "|" + this.path + "|" + con2 + "|" + value + "\" />";
    }
    tag += "</div>";
    return tag;
  };
  return AdlAttribute;
})();
ConditionBox = (function() {
  function ConditionBox(type, name, path, con, value) {
    this.type = type;
    this.name = name;
    this.path = path;
    this.con = con;
    this.value = value;
  }
  ConditionBox.prototype.toHtml = function(num, cnt) {
    var con, i, tag, _ref, _ref2;
    this.num = num;
    this.cnt = cnt;
    tag = "<div>";
    tag += "<select class=\"order\" name=\"" + this.cnt + "\">";
    for (i = 1, _ref = this.num; 1 <= _ref ? i <= _ref : i >= _ref; 1 <= _ref ? i++ : i--) {
      if (i === this.cnt) {
        tag += "<option value=\"" + i + "\" selected=\"selected\">" + i + "</option>";
      } else {
        tag += "<option value=\"" + i + "\">" + i + "</option>";
      }
    }
    tag += "</select> ";
    tag += "<input type=\"hidden\" class=\"forOrder\" value=\"" + this.type + "|" + this.name + "|" + this.path + "|" + this.con + "|" + this.value + "\" />";
    con = (_ref2 = this.con) != null ? _ref2.replace("%big%", "&lt;") : void 0;
    con = con != null ? con.replace("%small%", "&gt;") : void 0;
    switch (this.type) {
      case "dv_quantity_unit":
        tag += "" + this.name + " [unit] = " + this.value;
        break;
      case "dv_quantity":
        tag += "" + this.name + " [magnitude] " + con + " " + this.value;
        break;
      case "exists":
        tag += "" + this.name + " exists";
        break;
      case "in":
      case "notin":
      case "equals":
        tag += "" + this.name + " " + this.type + " [object]";
        break;
      default:
        tag += "" + this.name + " " + con + " " + this.value;
    }
    tag += "<input type=\"hidden\" class=\"conditionbox\" value=\"";
    switch (this.type) {
      case "dv_quantity_unit":
        tag += "" + this.path + "/units = '" + this.value + "'";
        break;
      case "dv_quantity":
        tag += "" + this.path + "/magnitude " + this.con + " " + this.value;
        break;
      case "dv_boolean":
      case "dv_count":
      case "dv_ordinal":
      case "devide":
        tag += "" + this.path + " " + this.con + " " + this.value;
        break;
      case "exists":
        tag += "exists {'" + this.path + "'}";
        break;
      case "in":
      case "notin":
      case "equals":
        tag += "" + this.path + " " + this.con + " %cr%(" + this.value + ")";
        break;
      default:
        tag += "" + this.path + " " + this.con + " '" + this.value + "'";
    }
    tag += "\" />";
    tag += "</div>";
    return tag;
  };
  ConditionBox.prototype.operation = function() {
    return "<select class=\"operation\">" + "<option value=\"AND\">AND</option>" + "<option value=\"OR\">OR</option>" + "</select>";
  };
  return ConditionBox;
})();