package jp.ac.u_aizu.wako3.aqbe.snippet

import scala.xml.NodeSeq
import scala.xml.Xhtml

import scala.util.control.Exception._
import jp.ac.u_aizu.wako3.aqbe._
import jp.ac.u_aizu.wako3.concept.ConceptList
import jp.ac.u_aizu.wako3.concept.ConceptParser
import net.liftweb.http.SHtml.ajaxCall
import net.liftweb.http.SHtml.text
import net.liftweb.http.S.{ ? ⇒ ? }
import net.liftweb.http.js.JE.ValById
import net.liftweb.http.js.JsCmd
import net.liftweb.http.js.JsCmds
import net.liftweb.http.S
import net.liftweb.util.Helpers.bind
import net.liftweb.util.Helpers.pairToUnprefixed
import net.liftweb.util.Helpers.strToBPAssoc
import net.liftweb.util.Helpers.strToSuperArrowAssoc

class SelectConcept extends AdlTo {
  def show(xhtml: NodeSeq): NodeSeq = {
    bind("concept", xhtml,
      "selectConceptForm" --> <input type="hidden" name="selectConceptForm"/> % ("value" -> S.param("selectConceptForm").openOr("")),
      "conceptField" --> ConceptList(Settings.AdlPath).getHtml % ("name" -> "selectConcept"),
      "inlineField" --> <input type="hidden" name="inlineField"/> % ("value" -> S.param("inlineField").openOr(""))
    )
  }
  def concept = {
    val text = S.param("selectConceptForm").openOr("")
    println(text);
    text match {
      case "" ⇒ <xml:group></xml:group>
      case item ⇒ {
        val isComposition = """openEHR-EHR-COMPOSITION\.(.*)\.v.+""".r
        val isAdl = """openEHR-EHR-(.*)\.(.*)\.v.+""".r
        val xml = ConceptParser(item.replace(".adl", "")) map {
          _.getOrElse(List())
        } zipWithIndex

        <xml:group>
          <div id="xml">
            <table>
              <tr><th>EHR</th><th>COMPOSITION</th><th>ENTRY</th></tr>
              <tr>
                <td>
                  <select size="5" id="selectEHR">
                    <option name="EHR" value="EHR">EHR</option>
                  </select>
                </td>
                <td>
                  {
                    <select size="5" id="selectComposition">
                      {
                        xml map {
                          x ⇒
                            x._1 map {
                              node ⇒
                                node match {
                                  case isComposition(n)⇒ <option name={ node.toString } value={ "COMPOSITION" + n } join={ x._2.toString }>{ n }</option>
                                  case _⇒
                                }
                            }
                        }
                      }
                    </select>
                  }
                </td>
                <td>
                  {
                    <select size="5" id="selectEntry">
                      {
                        xml map {
                          x ⇒
                            x._1 map {
                              node ⇒
                                node match {
                                  case isComposition(n)⇒
                                  // TODO カテゴリー表示をしない
                                  case isAdl(t, n)⇒ <option name={ node.toString } value={ t + n } join={ x._2.toString }>{ n }</option>
//                                  case isAdl(t, n)⇒ <option name={ node.toString } value={ t + n } join={ x._2.toString }>{ t + " : " + n }</option>
                                  case _⇒
                                }
                            }
                        }
                      }
                    </select>
                  }
                </td>
              </tr>
            </table>
          </div>
          <div id="aqbe">
            <div id="ehr" class="aqbe_table" name="-1" style="display: none;">
              <table>
                <tr>
                  <td>
                    <input type="checkbox" class="checkbox" name="*" value="*"/>
                    <strong>EHR</strong>
                  </td>
                  <td>
                    <input type="hidden" class="input_condition" name="-1a" value="Input Condition"/>
                    <input type="button" class="input_function" name="-1a" value="Input Function"/>
                    <input type="hidden" class="name" name="-1a" value=""/>
                    <input type="hidden" class="path" name="-1a" value=""/>
                    <div class="-1afunc" name="func" style="display: none;">
                      <select class="function" name="-1a">
                        <option value="count">count</option>
                      </select>
                      <span func="func-1a"></span>
                      <input type="button" value="Input" name="-1a" class="inputfunction" onclick="inputfunction(this)"/>
                    </div>
                    <div class="-1ashow" name="show" style="display: block;"></div>
                  </td>
                </tr>
                <tr>
                  <td>
                    <input type="checkbox" class="checkbox" name="/ehr_id" value="-2"/>
                    ehr_id
                  </td>
                  <td>
                    <input type="hidden" class="input_condition" name="-2a" value="Input Condition"/>
                    <input type="button" class="input_function" name="-2a" value="Input Function"/>
                    <input type="hidden" class="name" name="-2a" value=""/>
                    <input type="hidden" class="path" name="-2a" value="/ehr_id"/>
                    <div class="-2afunc" name="func" style="display: none;">
                      <select class="function" name="-2a">
                        <option value="count">count</option>
                      </select>
                      <span func="func-2a"></span>
                      <input type="button" value="Input" name="-2a" class="inputfunction" onclick="inputfunction(this)"/>
                    </div>
                    <div class="-2ashow" name="show" style="display: block;"></div>
                  </td>
                </tr>
              </table>
              <center><input type="button" value="Send ConditionBox" name="-1" class="sendConditionBox"/></center>
            </div>
            {
              xml.map(_._1).flatten.map(AdlParser(_)).flatten.map(_.asInstanceOf[ParsedAdl].getConcept).flatten map {
                node ⇒
                  {
                    <div id={
                      node match {
                        case _: AdlComposition⇒ "COMPOSITION" + node.name
                        case _: AdlSection⇒ "SECTION" + node.name
                        case _: AdlObservation⇒ "OBSERVATION" + node.name
                        case _: AdlItemTree⇒ "ITEM_TREE" + node.name
                        case _: AdlEvaluation⇒ "EVALUATION" + node.name
                        case _: AdlInstruction⇒ "INSTRUCTION" + node.name
                        case _: AdlAction⇒ "ACTION" + node.name
                        case _: AdlAdminEntry⇒ "ADMIN_ENTRY" + node.name
                        case _       ⇒ node.name
                      }
                    } class="aqbe_table" name={ node.hashCode.toString } style="display: none;">
                      <table>{ getAttribute(node) }</table>
                      <center><input type="button" value="Send ConditionBox" name={ node.hashCode.toString } class="sendConditionBox"/></center>
                    </div>
                  }
              }
            }
          </div>
        </xml:group>
      }
    }
  }

  private def getAttribute(node: Concept) = {
    <xml:group>
      <tr>
        <td>
          <input type="checkbox" class="checkbox" name="*" value="*"/>
          <strong>{ node.name }</strong>
        </td>
        <td>
          <input type="hidden" class="input_condition" name={ node.hashCode.toString + "a" } value="Input Condition"/>
          <input type="button" class="input_function" name={ node.hashCode.toString + "a" } value="Input Function"/>
          <input type="hidden" class="name" name={ node.hashCode.toString + "a" } value={ node.name }/>
          <input type="hidden" class="path" name={ node.hashCode.toString + "a" } value=""/>
          <div class={ node.hashCode.toString + "afunc" } name="func" style="display: none;">
            <select class="function" name={ node.hashCode.toString + "a" }>
              <option value="count">count</option>
              <option value="rename">rename</option>
            </select>
            <span func={ "func" + node.hashCode.toString + "a" }></span>
            <input type="button" value="Input" name={ node.hashCode.toString + "a" } class="inputfunction" onclick="inputfunction(this)"/>
          </div>
          <div class={ node.hashCode.toString + "ashow" } name="show" style="display: block;"></div>
        </td>
      </tr>
      <tr>
        <td>
          <input type="checkbox" class="checkbox" name="/name/value" value={ node.hashCode.toString + "n" }/>
          Name
        </td>
        <td>
          <input type="button" class="input_condition" name={ node.hashCode.toString + "n" } value="Input Condition"/>
          <input type="button" class="input_function" name={ node.hashCode.toString + "n" } value="Input Function"/>
          <input type="hidden" class="name" name={ node.hashCode.toString + "n" } value={ node.name + " [name]" }/>
          <input type="hidden" class="path" name={ node.hashCode.toString + "n" } value="/name/value"/>
          <div class={ node.hashCode.toString + "n" } name="show" style="display: none;">
            <select class="condition" name={ node.hashCode.toString + "n" }>
              <option value="eq">=</option>
              <option value="not">!=</option>
            </select>
            <input type="text" class="node_name" name={ node.hashCode.toString + "n" } placeholder="Free text"/>
            <input type="button" value="Input" name={ node.hashCode.toString + "n" } class="input" onclick="input(this)"/>
          </div>
          <div class={ node.hashCode.toString + "nfunc" } name="func" style="display: none;">
            <select class="function" name={ node.hashCode.toString + "n" }>
              <option value="count">count</option>
              <option value="rename">rename</option>
            </select>
            <span func={ "func" + node.hashCode.toString + "n" }></span>
            <input type="button" value="Input" name={ node.hashCode.toString + "n" } class="inputfunction" onclick="inputfunction(this)"/>
          </div>
          <div class={ node.hashCode.toString + "nshow" } name="show" style="display: block;"></div>
        </td>
      </tr>
      <tr>
        <td>
          <input type="checkbox" class="checkbox" name="/context/start_time" value={ node.hashCode.toString + "x" }/>
          Context
        </td>
        <td>
          <input type="button" class="input_condition" name={ node.hashCode.toString + "x" } value="Input Condition"/>
          <input type="button" class="input_function" name={ node.hashCode.toString + "x" } value="Input Function"/>
          <input type="hidden" class="name" name={ node.hashCode.toString + "x" } value={ node.name + " [context]" }/>
          <input type="hidden" class="path" name={ node.hashCode.toString + "x" } value="/context/start_time"/>
          <div class={ node.hashCode.toString + "x" } name="show" style="display: none;">
            <select class="condition" name={ node.hashCode.toString + "x" }>
              <option value="eq">=</option>
              <option value="not">!=</option>
            </select>
            <input type="text" class="node_context" name={ node.hashCode.toString + "x" } placeholder="Free text"/>
            <input type="button" value="Input" name={ node.hashCode.toString + "x" } class="input" onclick="input(this)"/>
          </div>
          <div class={ node.hashCode.toString + "xfunc" } name="func" style="display: none;">
            <select class="function" name={ node.hashCode.toString + "x" }>
              <option value="count">count</option>
              <option value="rename">rename</option>
            </select>
            <span func={ "func" + node.hashCode.toString + "x" }></span>
            <input type="button" value="Input" name={ node.hashCode.toString + "x" } class="inputfunction" onclick="inputfunction(this)"/>
          </div>
          <div class={ node.hashCode.toString + "xshow" } name="show" style="display: block;"></div>
        </td>
      </tr>
      <tr>
        <td>
          <input type="checkbox" class="checkbox" name="/composer/name" value={ node.hashCode.toString + "m" }/>
          Composer
        </td>
        <td>
          <input type="button" class="input_condition" name={ node.hashCode.toString + "m" } value="Input Condition"/>
          <input type="button" class="input_function" name={ node.hashCode.toString + "m" } value="Input Function"/>
          <input type="hidden" class="name" name={ node.hashCode.toString + "m" } value={ node.name + " [composer]" }/>
          <input type="hidden" class="path" name={ node.hashCode.toString + "m" } value="/composer/name"/>
          <div class={ node.hashCode.toString + "m" } name="show" style="display: none;">
            <select class="condition" name={ node.hashCode.toString + "m" }>
              <option value="eq">=</option>
              <option value="not">!=</option>
            </select>
            <input type="text" class="node_composer" name={ node.hashCode.toString + "m" } placeholder="Free text"/>
            <input type="button" value="Input" name={ node.hashCode.toString + "m" } class="input" onclick="input(this)"/>
          </div>
          <div class={ node.hashCode.toString + "mfunc" } name="func" style="display: none;">
            <select class="function" name={ node.hashCode.toString + "m" }>
              <option value="count">count</option>
              <option value="rename">rename</option>
            </select>
            <span func={ "func" + node.hashCode.toString + "m" }></span>
            <input type="button" value="Input" name={ node.hashCode.toString + "m" } class="inputfunction" onclick="inputfunction(this)"/>
          </div>
          <div class={ node.hashCode.toString + "mshow" } name="show" style="display: block;"></div>
        </td>
      </tr>
      {
        node match {
          case AdlObservation(name, dataList, stateList, protocolList) ⇒ {
            <xml:group>
              <tr><th colspan="2">Data</th></tr>
              {
                dataList map { createNode(_) }
              }
              <tr><th colspan="2">State</th></tr>
              {
                stateList map { createNode(_) }
              }
              <tr><th colspan="2">Protocol</th></tr>
              {
                protocolList map { createNode(_) }
              }
            </xml:group>
          }
          case AdlComposition(name, contextList) ⇒ {
            <xml:group>
              <tr><th colspan="2">Context</th></tr>
              {
                contextList map { createNode(_) }
              }
            </xml:group>
          }
          case AdlItemTree(name, dataList) ⇒ {
            <xml:group>
              <tr><th colspan="2">Data</th></tr>
              {
                dataList map { createNode(_) }
              }
            </xml:group>
          }
          case AdlEvaluation(name, dataList) ⇒ {
            <xml:group>
              <tr><th colspan="2">Data</th></tr>
              {
                dataList map { createNode(_) }
              }
            </xml:group>
          }
          case AdlInstruction(name, dataList) ⇒ {
            <xml:group>
              <tr><th colspan="2">Data</th></tr>
              {
                dataList map { createNode(_) }
              }
            </xml:group>
          }
          case AdlAction(name, dataList) ⇒ {
            <xml:group>
              <tr><th colspan="2">Data</th></tr>
              {
                dataList map { createNode(_) }
              }
            </xml:group>
          }
          case AdlAdminEntry(name, dataList) ⇒ {
            <xml:group>
              <tr><th colspan="2">Data</th></tr>
              {
                dataList map { createNode(_) }
              }
            </xml:group>
          }
          case AdlSection(name) ⇒ {
            <xml:group>
            </xml:group>
          }
          case _ ⇒ {
            <xml:group></xml:group>
          }
        }
      }
    </xml:group>
  }
}
