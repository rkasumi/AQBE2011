# アニメーション設定
$ ->
  loadEvent()
  initInline()


loadEvent = ->
  # XML表示画面へのロード画像 - ajaxのため終了処理はscala
  $("#selectConcept").change ->
    if $("[name=selectConceptForm]").val() == ""
      val = $(@).val()
    else
      val = $("[name=selectConceptForm]").val() + "," + $(@).val()
    $("[name=selectConceptForm]").val(val)

  $("[name=selectConceptSubmit]").click ->
    $("#xml").hide(100)
    $("#aqbe").hide(100)
    $("#concept").hide(100)
    $("#condition").hide(100)
    $("#showAql").hide(100)
    $("#loading").slideDown(100)
    $("form").submit()

  # XML中のADLを選択したらADLを表示切り替え
  $("#selectEHR").click ->
    $("[name=selectedConcept]").val("e")
    $("#aqbe").slideUp(100)
    $(".aqbe_table").hide()
    $("#ehr").show()
    $("#aqbe").slideDown(300)
    $("#condition").hide(300)

  $("#selectComposition").click ->
    i = 0
    num = 0
    val = $(@).val()
    val2 = val + $(@).children(":selected").attr("join")
    # 選択中のコンセプト番号を取得して表示
    $("#selectComposition option, #selectComposition option").each( ->
      if ($(@).val() + $(@).attr("join")) is val2 then num = i
      i++
    )
    $("[name=selectedConcept]").val("c#{num}")

    # 選択されたかどうかを確認する部分
    selectedValue = $(@).children(":selected").attr("name")
    selectedJoin = $(@).children(":selected").attr("join")
    select = "COMPOSITION" if selectedValue.indexOf("COMPOSITION") != -1
    fromV = "#{selectedJoin},#{select} c#{num}[#{selectedValue}]"
    if $("#fromConcept").val() == ""
      $("#fromConcept").val(fromV)
    else if $("#fromConcept").val().indexOf(fromV) == -1
      $("#fromConcept").val($("#fromConcept").val() + "|" + fromV)

    # アニメーション
    $("#aqbe").slideUp(100)
    $(".aqbe_table").hide()
    $("##{$(@).val()}").show()
    $("#aqbe").slideDown(300)
    $("#condition").hide(300)

  $("#selectEntry").click ->
    i = 0
    num = 0
    val = $(@).val()
    val2 = val + $(@).children(":selected").attr("join")
    # 選択中のコンセプト番号を取得して表示
    $("#selectComposition option, #selectEntry option").each( ->
      if ($(@).val() + $(@).attr("join")) is val2 then num = i
      i++
    )
    $("[name=selectedConcept]").val("c#{num}")

    # 選択されたかどうかを確認する部分
    selectedValue = $(@).children(":selected").attr("name")
    join = $(@).children(":selected").attr("join")
    select = "OBSERVATION" if selectedValue.indexOf("OBSERVATION") != -1
    select = "SECTION" if selectedValue.indexOf("SECTION") != -1
    select = "ITEM_TREE" if selectedValue.indexOf("ITEM_TREE") != -1
    select = "EVALUATION" if selectedValue.indexOf("EVALUATION") != -1
    select = "INSTRUCTION" if selectedValue.indexOf("INSTRUCTION") != -1
    select = "ACTION" if selectedValue.indexOf("ACTION") != -1
    select = "ADMIN_ENTRY" if selectedValue.indexOf("ADMIN_ENTRY") != -1

    $("#selectComposition option").each( ->
      if $(@).attr("join") == join
        val = $(@).val()
        val2 = val + join
        i2 = 0
        num2 = 0
        $("#selectComposition option, #selectEntry option").each( ->
          if ($(@).val() + $(@).attr("join")) is val2 then num2 = i2
          i2++
        )
        name = $(@).attr("name")
        fromV = "#{join},COMPOSITION c#{num2}[#{name}]"
        if $("#fromConcept").val() == ""
          $("#fromConcept").val(fromV)
        else if $("#fromConcept").val().indexOf(fromV) == -1
          $("#fromConcept").val($("#fromConcept").val() + "|" + fromV)
    )

    fromV = "#{join},#{select} c#{num}[#{selectedValue}]"
    if $("#fromConcept").val() == ""
      $("#fromConcept").val(fromV)
    else if $("#fromConcept").val().indexOf(fromV) == -1
      $("#fromConcept").val($("#fromConcept").val() + "|" + fromV)


    # アニメーション
    $("#aqbe").slideUp(100)
    $(".aqbe_table").hide()
    $("##{$(@).val()}").show()
    $("#aqbe").slideDown(300)
    $("#condition").hide(300)

  # 条件入力画面の開閉
  $(".input_condition").click ->
    obj = $("." +  $(@).attr("name"))
    objF = $("." +  $(@).attr("name") + "func")
    if(obj.is(":hidden"))
      obj.slideDown(200)
      objF.hide()
      $(@).val("Close Condition")
      $(@).next().val("Input Function")
    else
      obj.slideUp(200)
      $(@).val("Input Condition")
    exit()

  # function入力画面の開閉
  $(".input_function").click ->
    obj = $("." +  $(@).attr("name") + "func")
    objC = $("." +  $(@).attr("name"))
    if(obj.is(":hidden"))
      obj.slideDown(200)
      objC.hide()
      $(@).val("Close Function")
      $(@).prev().val("Input Condition")
    else
      obj.slideUp(200)
      $(@).val("Input Function")
    exit()

  # DvQuantityの複数条件切り替え
  $(".dv_quantity_unit").change ->
    hash = $(@).attr("name")
    min = $(@).children(":selected").attr("min")
    max = $(@).children(":selected").attr("max")
    min = "-2147483648" unless min?
    max = "2147483647" unless max?
    $("[name=#{hash}][min]").attr({"min": min})
    $("[name=#{hash}][max]").attr({"max": max})

  # コンディションボックスに送信
  $(".sendConditionBox").click ->
    param = {}
    i = 0

    $("[name=#{$(@).attr("name")}] .value").each(-> param[i++] = $(@).val())

    unless i == 0
      # operation
      unless $("#sendCount").val() is "0"
        temp = "<select class=\"operation\">" +
        "<option value=\"AND\">AND</option>" +
        "<option value=\"OR\">OR</option>" +
        "</select>"
        $("#condition").append(temp) # オペレーションを追加
        $(".orderButoon").remove() # 更新ボタンを削除

      # where & operation
      num = 0
      for key, value of param
        num++
      tempNum = $("#sendCount").val() - 0
      num = num + tempNum
      $("#sendCount").val(num)

      cnt = 1
      for key, value of param
        [type, name, path, con, val] = value.split("|")
        conditionBox = new ConditionBox(type, name, path, con, val)
        $("#condition").append(conditionBox.toHtml(num, (cnt++)+tempNum))
        $("#condition").append(conditionBox.operation())

      $($(".operation")[$(".operation").length-1]).remove()

      tag = "<input type=\"button\" class=\"orderButoon\" value=\"update order\" />"
      $("#condition").append(tag)

      loadEvent()

    # select
    checkFlag = 0
    $(".checkbox").each(->
      if $(@).is(":checked") == true
        if $(@).attr("name") is "*"
          checkFlag = 1
          t = "<input type=\"hidden\" class=\"checkedBox\" value=\"#{$("[name=selectedConcept]").val()}\" />"
          $("#condition").append(t)
        unless checkFlag == 1
          t = "<input type=\"hidden\" class=\"checkedBox\" value=\"#{$("[name=selectedConcept]").val()}#{$(@).attr("name")}\" />"
          $("#condition").append(t)
    )
    $(".functionalSelect").each( ->
      t = "<input type=\"hidden\" class=\"checkedBox\" value=\"#{$(@).val()}\" />"
      $("#condition").append(t)
    )

    # alldelete
    $(".object").each(-> $(@).remove())
    $(":checked").each( ->
      $(@)[0].checked = false
      return
    )

    # display
    orderFunction()
    $("#aqbe").hide(300)
    $("#showAql").hide(300)
    $("#condition").slideDown(300)


  $(".function").change ->
    hash = $(@).attr("name")
    $("[func=func#{hash}]").children().each( -> $(@).remove())
    switch $(@).val()
      when "rename"
        param = {}
        $("[name=#{hash}]").each( -> param[$(@).attr("class")] = $(@).val())
        for key, value of param
          switch key
            when "name" then name = value
            when "path" then path = $("[name=selectedConcept]").val() + value
        tag = "<input type=\"text\" class=\"#{hash}_rename\" name=\"#{path}\" value=\"\" placeholder=\"#{name}\" />"
        $(@).next().append(tag)
      when "devide"
        param = {}
        $("[name=#{hash}]").each( -> param[$(@).attr("class")] = $(@).val())
        for key, value of param
          switch key
            when "name" then name = value
            when "path" then path = $("[name=selectedConcept]").val() + value
        tag  = "<span>#{name} / </span>"
        tag += "<select class=\"#{hash}_devide\" name=\"#{path}\">"
        $(".forDevide").each( -> tag += "<option value=\"#{$(@).val()}\">#{$(@).attr("name")}</option>")
        tag += "</select>"
        tag += "<select class=\"#{hash}_devide_condition\">"
        tag += "<option value=\"eq\">=</option>"
        tag += "<option value=\"not\">!=</option>"
        tag += "<option value=\"big\">&lt;</option>"
        tag += "<option value=\"small\">&gt;</option>"
        tag += "<option value=\"bigeq\">&lt;=</option>"
        tag += "<option value=\"smalleq\">&gt;=</option>"
        tag += "</select>"
        tag += "<input type=\"number\" class=\"#{hash}_devide_value\" value=\"0.0\" step=\"0.01\" />"
        $(@).next().append(tag)
      when "in", "notin", "equals"
        param = {}
        $("[name=#{hash}]").each( -> param[$(@).attr("class")] = $(@).val())
        for key, value of param
          switch key
            when "name" then name = value
            when "path" then path = $("[name=selectedConcept]").val() + value
        tag  = "<span>#{name} #{$(@).val()} [object]</span>"
        tag += "<input type=\"hidden\" class=\"#{hash}_#{$(@).val()}\" name=\"#{name}\" path=\"#{path}\" value=\"\" />"
        $(@).next().append(tag)
        $("#content").hide(500)
        baseUrl = $("h1 a").attr("href")
        $("#inline iframe").attr("src", "#{baseUrl}?inlineField=#{hash}_#{$(@).val()}")
        $("#inline").slideDown(500)




  $("#generateAql").click ->
    query = {}

    # FROM
    contain = {}
    for v in $("#fromConcept").val().split("|")
      [a1, a2] = v.split(" ")
      [a3, a4] = a2.split("[")
      contain["#{a3}"] = a4.replace(/\./g, "___").replace("]", "")

    # SELECT
    selection = {}
    $(".checkedBox").each( ->
      listNum = $(@).val().split("/")
      cond = $(@).val().replace(listNum[0], contain["#{listNum[0]}"] + ".").replace(/\.$/, "")
      selection["#{cond}"] = 1
    )
    query["selection"] = selection

    # WHERE
    condition = {}
    tagTemp = ""
    v = {}
    c = {}
    i = 0
    $(".conditionbox").each( -> v["#{i++}"] = $(@).val())
    i = 0
    $(".operation").each( -> c["#{i++}"] = $(@).val())

    for key, value of v
      vList = value.split(" ")
      listNum = value.split("/")
      vListPath = vList[0].replace(listNum[0], contain["#{listNum[0]}"] + ".")
      vListCond = vList[1]
      vListCond = vListCond.replace("%big%", "$lt").replace("%small%", "$gt")
      vListValue = ""
      vi = 0
      for vl in vList
        unless vi is 0 or vi is 1
          vListValue += vl + " "
        vi += 1
      vListValue = vListValue.replace(/\s$/, "").replace(/'/g, "")

      temp = {}
      temp["#{vListPath}"] = vListValue
      if vListCond is "$lt"
        vListValue = {"$lt": temp}
      if vListCond is "$gt"
        vListValue = {"$gt": temp}
      console.log vListValue

      if c[key] is "OR"
        if temp?
          condition["$or"] = [temp, {vListPath, vListValue}]
          temp = undefined
        else
          temp = [vListPath, vListValue]
      else
        condition["#{vListPath}"] = vListValue

    query["condition"] = condition

    # display
    $("#xml").hide(300)
    $("#condition").hide(300)

    # inline用
    # unless $("[name=inlineField]").val() == ""
      # $("#inlineArea").val(tag.replaceAll("\n", "%cr%").replaceAll("\t", "%tab%"))
      # $(".inlineShow").show()
      #

    $.ajax(
      type: "POST"
      url: "http://wako3.u-aizu.ac.jp:8080/service/find"
      data: JSON.stringify(query)
      contentType: "text/json"
      dataType: "json"
      success: (data) ->
        console.log data
    )


    # ＜＞を小文字に変換してtextareaに追加
    $("#showAql textarea").val(JSON.stringify(query))

    $("#showAql").slideDown(300)

  # 並び替え用
  $(".orderButoon").click ->
    orderFunction()

initDelete = ->
  # 入力済みの条件を削除
  $(".delete").click ->
    hash = $(@).attr("name")
    $("[name=#{hash}]").hide(100, -> $("[name=#{hash}]").remove())

  return

initInline = ->
  # iframeの高さ調整
  $("iframe").load ->
    $(@).height(@.contentWindow.document.documentElement.scrollHeight+10)
    $("iframe").triggerHandler("load")

  # iframe上から親へ送信処理
  $("#inlineButton").click ->
    inlineHash = $("[name=inlineField]").val()
    result =  $("#inlineArea").val()
    $(".#{inlineHash}", window.parent.document).val(result)
    $("#content", window.parent.document).slideDown(500)
    $("#inline", window.parent.document).slideUp(500)


String.prototype.replaceAll = (org,  dest) ->
    return this.split(org).join(dest);

# 条件入力処理
conditionCount = 0

# Inputボタン
input = (obj) ->
  hash = $(obj).attr("name")
  param = {}
  $("[name=#{hash}]").each( -> param[$(@).attr("class")] = $(@).val())

  valueList = {}
  for key, value of param
    switch key
      when "input_condition", "input_function", "function", "input", "inputfunction", "function" then value
      when "name" then name = value
      when "path" then path = $("[name=selectedConcept]").val() + value
      when "condition" then condition = value
      else
        valueList[key] = value

  number = "#{hash}_num#{conditionCount++}"
  adl = new AdlAttribute(name, path, condition, valueList, number)
  $(".#{hash}show").append(adl.toHtml())
  $("[name=#{number}]").show(100)

  initDelete()

# Inputボタン (function)
inputfunction = (obj) ->
  hash = $(obj).attr("name")
  param = {}
  $("[name=#{hash}]").each( -> param[$(@).attr("class")] = $(@).val())

  for key, value of param
    switch key
      when "name" then name = value
      when "path" then path = $("[name=selectedConcept]").val() + value

  number = "#{hash}_num#{conditionCount++}"
  funcValue = $(".#{hash}func .function").val()
  switch funcValue
    when "exists"
      tag  = "<div class=\"object\" name=\"#{number}\">"
      tag += "<input type=\"button\" value=\"x\" class=\"delete\" name=\"#{number}\" /> "
      tag += "exists"
      tag += "<input class=\"value\" type=\"hidden\" value=\"exists|#{name}|#{path}||\" />"
      tag += "</div>"
    when "count"
      tag  = "<div class=\"object\" name=\"#{number}\">"
      tag += "<input type=\"button\" value=\"x\" class=\"delete\" name=\"#{number}\" /> "
      tag += "count"
      tag += "<input class=\"functionalSelect\" type=\"hidden\" value=\"COUNT(#{path})\" />"
      tag += "</div>"
    when "rename"
      tag  = "<div class=\"object\" name=\"#{number}\">"
      tag += "<input type=\"button\" value=\"x\" class=\"delete\" name=\"#{number}\" /> "
      tag += "rename #{$(".#{hash}_rename").val()}"
      tag += "<input class=\"functionalSelect\" type=\"hidden\" value=\"#{path} AS '#{$(".#{hash}_rename").val()}'\" />"
      tag += "</div>"
    when "devide"
      tempName = name + " / " + $(".#{hash}_devide option:selected").text()
      tempPath = "(" + path + "/magnitude / " + $("[name=selectedConcept]").val() + $(".#{hash}_devide").val() + "/magnitude)"
      tempCon  = $(".#{hash}_devide_condition option:selected").val()
      switch tempCon
        when "eq" then con = "="; con2 = "="
        when "not" then con = "!="; con2 = "!="
        when "big" then con = "&lt;"; con2 = "%big%"
        when "small" then con =  "&gt;"; con2 = "%small%"
        when "bigeq" then con = "&lt;="; cons2 = "%big%="
        when "smalleq" then con = "&gt;="; con2 = "%small%="
        else
          con = "="
      tempVal  = $(".#{hash}_devide_value").val()
      tag  = "<div class=\"object\" name=\"#{number}\">"
      tag += "<input type=\"button\" value=\"x\" class=\"delete\" name=\"#{number}\" /> "
      tag += "#{tempName} #{con} #{tempVal}"
      tag += "<input class=\"value\" type=\"hidden\" value=\"devide|#{tempName}|#{tempPath}|#{con2}|#{tempVal}\" />"
      tag += "</div>"
    when "in", "notin", "equals"
      tag  = "<div class=\"object\" name=\"#{number}\">"
      tag += "<input type=\"button\" value=\"x\" class=\"delete\" name=\"#{number}\" /> "
      tag += "#{name} #{funcValue} [object]"
      tag += "<input class=\"value\" type=\"hidden\" value=\"#{funcValue}|#{name}|#{path}|#{funcValue}|#{$(".#{hash}_#{funcValue}").val()}\" />"
      tag += "</div>"
  $(".#{hash}show").append(tag)
  $("[name=#{number}]").show()
  initDelete()

# currentdate ファンクション
openGenerateDate = (obj) ->
  $(obj).next().toggle()
generateDate = (obj) ->
  num = $(obj).prev().prev().val()
  type = $(obj).prev().val()
  if num is "0"
    value = "current-date()"
  else
    value = "current-date() - P#{num}#{type}"
  target = $(obj).parent().prev().prev()
  target.val(value)
  $(obj).parent().hide()

orderFunction = (obj) ->
  # error check
  i = 0
  error = 0
  errorList = []
  $(".order").each( ->
    if $(@).val() in errorList then error = 1
    errorList += $(@).val()
  )

  if error == 0

    # 初期化
    param = {}
    param2 = {}
    num = 1
    $(".forOrder").each( -> param[num++] = $(@).val())
    num = 1
    $(".order").each( -> param2[num++] = $(@).val())

    # 古い要素を削除
    $("#condition div").each(-> $(@).remove())
    $("#condition .operation").each(-> $(@).remove())
    $("#condition .orderButoon").each(-> $(@).remove())

    cnt = 1
    for i in [1..num-1]
      for k, v of param2
        if "#{i}" == "#{v}"
          [type, name, path, con, val] = param[k].split("|")
          conditionBox = new ConditionBox(type, name, path, con, val)
          $("#condition").append(conditionBox.toHtml(num-1, cnt++))
          $("#condition").append(conditionBox.operation())

    $($(".operation")[$(".operation").length-1]).remove()

    tag = "<input type=\"button\" class=\"orderButoon\" value=\"update order\" />"
    $("#condition").append(tag)

    # select
    checkFlag = 0
    $(".checkbox").each(->
      if $(@).is(":checked") == true
        if $(@).attr("name") is "*"
          checkFlag = 1
          t = "<input type=\"hidden\" class=\"checkedBox\" value=\"#{$("[name=selectedConcept]").val()}\" />"
          $("#condition").append(t)
        unless checkFlag == 1
          t = "<input type=\"hidden\" class=\"checkedBox\" value=\"#{$("[name=selectedConcept]").val()}#{$(@).attr("name")}\" />"
          $("#condition").append(t)
    )
    $(".functionalSelect").each( ->
      t = "<input type=\"hidden\" class=\"checkedBox\" value=\"#{$(@).val()}\" />"
      $("#condition").append(t)
    )

    # alldelete
    $(".object").each(-> $(@).remove())

    # display
    $("#aqbe").hide(300)
    $("#showAql").hide(300)
    $("#condition").slideDown(300)
    loadEvent()
