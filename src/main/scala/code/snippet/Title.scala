package jp.ac.u_aizu.wako3.aqbe.snippet

import scala.xml.NodeSeq
import jp.ac.u_aizu.wako3.aqbe.AdlParser
import jp.ac.u_aizu.wako3.aqbe.Settings
import jp.ac.u_aizu.wako3.concept.ConceptList
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
import jp.ac.u_aizu.wako3.aqbe.ParsedAdl

import scala.io.Source
import se.acode.openehr.parser.{ ADLParser ⇒ ArchetypeParser };

class Title {
  def show = {
   S.param("inlineField").openOr("") match {
     case "" => <h1><a href={Settings.AppUrl}>AQBE - AQL generator</a></h1>
     case _ => <h1>Nested ... </h1>
   }
  }
}
