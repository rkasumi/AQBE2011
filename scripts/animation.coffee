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
    # 選択中のコンセプト番号を取得して表示
    $("#selectComposition option, #selectComposition option").each( ->
      if $(@).val() is val then num = i
      i++
    )
    $("[name=selectedConcept]").val("c#{num}")

    # 選択されたかどうかを確認する部分
    selectedValue = $(@).children(":selected").attr("name")
    selectedJoin = $(@).children(":selected").attr("join")
    select = "COMPOSITION" if selectedValue.indexOf("COMPOSITION") != -1
    if $("#fromConcept").val() == ""
      $("#fromConcept").val("#{selectedJoin},#{select} c#{num}[#{selectedValue}]")
    else if $("#fromConcept").val().indexOf(selectedValue) == -1
      $("#fromConcept").val($("#fromConcept").val() + "|#{selectedJoin},#{select} c#{num}[#{selectedValue}]")

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
    # 選択中のコンセプト番号を取得して表示
    $("#selectComposition option, #selectEntry option").each( ->
      if $(@).val() is val then num = i
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
    if $("#fromConcept").val() == ""
      $("#fromConcept").val("#{join},#{select} c#{num}[#{selectedValue}]")
    else if $("#fromConcept").val().indexOf(selectedValue) == -1
      $("#fromConcept").val($("#fromConcept").val() + "|#{join},#{select} c#{num}[#{selectedValue}]")

    $("#selectComposition option").each( ->
      if $(@).attr("join") == join
        val = $(@).val()
        i = 0
        $("#selectComposition option, #selectEntry option").each( ->
          if $(@).val() is val then num = i
          i++
        )
        name = $(@).attr("name")
        if $("#fromConcept").val() == ""
          $("#fromConcept").val("COMPOSITION c#{num}[#{name}]")
        else if $("#fromConcept").val().indexOf(name) == -1
          $("#fromConcept").val($("#fromConcept").val() + "|#{join},COMPOSITION c#{num}[#{name}]")
    )

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
        $("#condition").append(temp)
      $("#sendCount").val("1")

      # where & operation
      num = 0
      for key, value of param
        num++

      cnt = 1
      for key, value of param
        [type, name, path, con, val] = value.split("|")
        conditionBox = new ConditionBox(type, name, path, con, val)
        $("#condition").append(conditionBox.toHtml(num, cnt++))
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

    # display
    $("#aqbe").hide(300)
    $("#showAql").hide(300)
    $("#condition").slideDown(300)

  # 条件入力処理
  conditionCount = 0

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


  $(".inputfunction").click ->
    hash = $(@).attr("name")
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


  $(".input").click ->
    hash = $(@).attr("name")
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

  $("#generateAql").click ->
    # SELECT
    tag = "SELECT \n"
    selectFlag = 0
    $(".checkedBox").each( ->
      selectFlag = 1
      tag += "\t#{$(@).val()},\n"
    )
    tag = tag.replace(/,\n$/, "\n") if selectFlag == 1
    tag += "\t*\n" if selectFlag == 0

    # FROM
    tag += "FROM\n"
    tag += "\tEHR e[ehr_id=$ehrId]\n"
    i = 0
    from = {}
    for v in $("#fromConcept").val().split("|")
      [j, k] = v.split(",")
      unless from["#{j}"]?
        from["#{j}"] = "\t\t" + k + "\n"
      else
        from["#{j}"] += "\t\tCONTAINS " + k + "\n"

    # $("#selectComposition option, #selectEntry option").each( ->
      # temp = ""
      # temp += "COMPOSITION" if $(@).attr("name").indexOf("COMPOSITION") != -1
      # temp += "OBSERVATION" if $(@).attr("name").indexOf("OBSERVATION") != -1
      # temp += "SECTION" if $(@).attr("name").indexOf("SECTION") != -1
      # temp += "ITEM_TREE" if $(@).attr("name").indexOf("ITEM_TREE") != -1
      # temp += "EVALUATION" if $(@).attr("name").indexOf("EVALUATION") != -1
      # temp += "INSTRUCTION" if $(@).attr("name").indexOf("INSTRUCTION") != -1
      # temp += "ACTION" if $(@).attr("name").indexOf("ACTION") != -1
      # temp += "ADMIN_ENTRY" if $(@).attr("name").indexOf("ADMIN_ENTRY") != -1
      # temp += " c#{i++}[#{$(@).attr("name")}]\n"
    # )

    fromCount = 0
    for fromKey, fromValue of from then fromCount++
    if fromCount <= 1
      tag += "\tCONTAINS " + "#{fromValue}".replaceAll("\t\t", "\t").replace(/^\t/, "")
    else
      for fromKey, fromValue of from
        if fromKey == "0" then tag += "\tCONTAINS (\n"
        unless fromKey == "0" then tag += "\tAND\n"
        tag += "#{fromValue}"
      tag += "\t)\n"

    # WHERE
    tagTemp = ""
    v = {}
    c = {}
    i = 0
    $(".conditionbox").each( -> v["#{i++}"] = $(@).val())
    i = 0
    $(".operation").each( -> c["#{i++}"] = $(@).val())

    for key, value of v
      tagTemp += "\t#{value}"
      tagTemp += " #{c[key]}\n" if c[key]?

    tag += "WHERE\n" + tagTemp unless tagTemp == ""


    # display
    $("#xml").hide(300)
    $("#condition").hide(300)

    # inline用
    unless $("[name=inlineField]").val() == ""
      $("#inlineArea").val(tag.replaceAll("\n", "%cr%").replaceAll("\t", "%tab%"))
      $(".inlineShow").show()

    # ＜＞を小文字に変換してtextareaに追加
    tag = tag.replaceAll("%big%", "<")
    tag = tag.replaceAll("%small%", ">")
    tag = tag.replaceAll("notin", "not in")
    tag = tag.replaceAll("%cr%", "\n")
    tag = tag.replaceAll("%tab%", "\t")
    $("#showAql textarea").val(tag)

    $("#showAql").slideDown(300)

  # 並び替え用
  $(".orderButoon").click ->
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
