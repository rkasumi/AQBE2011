class AdlAttribute
  constructor: (@name, @path, @condition, @valueList, @hash) ->

  toHtml: ->
    # start div
    tag = "<div class=\"object\" name=\"#{@hash}\">"

    # delete button
    tag += "<input type=\"button\" value=\"x\" class=\"delete\" name=\"#{@hash}\" /> "

    # name
    tag += "#{@name} "

    # condition
    switch @condition
      when "eq" then con = "="; con2 = "="
      when "not" then con = "!="; con2 = "!="
      when "big" then con = "&lt;"; con2 = "%big%"
      when "small" then con =  "&gt;"; con2 = "%small%"
      when "bigeq" then con = "&lt;="; cons2 = "%big%="
      when "smalleq" then con = "&gt;="; con2 = "%small%="
      else
        con = "="
    tag += " #{con} "

    # value
    for key, value of @valueList
      tag += "#{value} "

    # input tag = hidden
    for key, value of @valueList
      tag += "<input type=\"hidden\" class=\"value\" value=\"#{key}|#{@name}|#{@path}|#{con2}|#{value}\" />"

    # end div
    tag += "</div>"

    return tag

class ConditionBox
  constructor: (@type, @name, @path, @con, @value) ->
  toHtml: (@num, @cnt) ->
    # start div
    tag = "<div>"

    # order
    tag += "<select class=\"order\" name=\"#{@cnt}\">"
    for i in [1..@num]
      if i == @cnt
        tag += "<option value=\"#{i}\" selected=\"selected\">#{i}</option>"
      else
        tag += "<option value=\"#{i}\">#{i}</option>"
    tag += "</select> "
    tag += "<input type=\"hidden\" class=\"forOrder\" value=\"#{@type}|#{@name}|#{@path}|#{@con}|#{@value}\" />"

    # display information
    con = @con?.replace("%big%", "&lt;");
    con = con?.replace("%small%", "&gt;")
    switch @type
      when "dv_quantity_unit" then tag += "#{@name} [unit] = #{@value}"
      when "dv_quantity"      then tag += "#{@name} [magnitude] #{con} #{@value}"
      when "exists"           then tag += "#{@name} exists"
      when "in", "notin", "equals"
        tag += "#{@name} #{@type} [object]"
      else
        tag += "#{@name} #{con} #{@value}"

    # input type=hidden conditionbox
    tag += "<input type=\"hidden\" class=\"conditionbox\" value=\""
    switch @type
      when "dv_quantity_unit" then tag += "#{@path}/units = '#{@value}'"
      when "dv_quantity"      then tag += "#{@path}/magnitude #{@con} #{@value}"
      when "dv_boolean", "dv_count", "dv_ordinal", "devide" then tag += "#{@path} #{@con} #{@value}"
      when "exists"           then tag += "exists {'#{@path}'}"
      when "in", "notin", "equals"
        tag += "#{@path} #{@con} %cr%(#{@value})"
      else
        tag += "#{@path} #{@con} '#{@value}'"
    tag += "\" />"

    # end div
    tag += "</div>"

    return tag

  operation: ->
    "<select class=\"operation\">" +
    "<option value=\"AND\">AND</option>" +
    "<option value=\"OR\">OR</option>" +
    "</select>"
