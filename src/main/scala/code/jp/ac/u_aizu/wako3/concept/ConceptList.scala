package jp.ac.u_aizu.wako3.concept

import scala.xml._

object ConceptList {
  def apply(path: String) = {
    val html = XML.load(path)
    val regrex = """openEHR-EHR-(.*)\.(.*)\..*\..*""".r

    val conceptList = {
      (html \\ "a") map (_.text) map {
        item ⇒
          item match {
            case regrex(dataType, dataName) ⇒ Some((dataType + " : " + dataName, item))
            case _                          ⇒ None
          }
      } flatten
    } sortWith (_._1 < _._1)
    new ConceptList(conceptList.toList)
  }
}
case class ConceptList(concept: List[(String, String)]) {
  def getHtml() = {
    <select id="selectConcept" name="selectConcept">
      <option selected="selected" value="false">Please Select Concept</option>
      {
        concept map {
          item ⇒ <option value={ item._2 }>{ item._1 }</option>
        }
      }
    </select>
  }
}