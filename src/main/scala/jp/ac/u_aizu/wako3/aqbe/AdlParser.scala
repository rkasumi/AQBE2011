package jp.ac.u_aizu.wako3.aqbe

import scala.io.Source
import scala.util.control.Exception._
import scala.collection.JavaConversions._

import org.openehr.am.archetype.Archetype;
import org.openehr.am.archetype.constraintmodel.CAttribute;
import org.openehr.am.archetype.constraintmodel.CComplexObject;
import org.openehr.am.archetype.constraintmodel.CMultipleAttribute;
import org.openehr.am.archetype.constraintmodel.CObject;
import org.openehr.am.archetype.ontology.ArchetypeTerm;
import org.openehr.am.archetype.ontology.OntologyDefinitions;
import org.openehr.am.openehrprofile.datatypes.text.CCodePhrase;
import se.acode.openehr.parser.{ ADLParser ⇒ ArchetypeParser };

/**
 * ADLファイル名を受け取ってパースを行ったADLを返すクラス
 * @param fileName ADLファイル名
 * @return ParsedAdlクラス
 */
object AdlParser {
  def apply(fileName: String): Option[Adl] = allCatch opt {
    val url = Settings.AdlPath + fileName + ".adl"
    val file = Source.fromURL(url, "UTF-8").getLines.toList mkString "\n"
    new ParsedAdl(new ArchetypeParser(file).parse)
  }
}

/**
 * ADLオブジェクトのsuperクラス
 * toStringをオーバーライド
 */
abstract class Adl {
  val name: String
  val id: String
  def getOntology(lang: String): Ontology
  override def toString = "ADL Name:\n\t" + name + "\nADL ID:\n\t" + id
}

/**
 * パース済みのADL
 * @param adl パースされたADLオブジェクト
 */
class ParsedAdl(adl: Archetype) extends Adl {
  val name = adl.getArchetypeId.getValue
  val id = adl.getConcept
  lazy val ontologyLanguage = adl.getOntology.getTermDefinitionsList.map(_.getLanguage).toList

  /**
   * 言語別のOntologyを返す
   * 言語指定なし、もしくは指定された言語が見つからない場合はリストの最初の言語を返す
   * @param lang 取得するOntologyの言語
   * @return Ontology
   */
  def getOntology(lang: String = "en"): Ontology = {
    def getDefinition(lang: String): List[(String, String, String)] = {
      adl.getOntology.getTermDefinitionsList.find(_.getLanguage == lang) match {
        case Some(ontology) ⇒ ontology.getDefinitions.map {
          o ⇒ (o.getCode, o.getText, o.getDescription)
        } toList
        case _ ⇒ getDefinition(ontologyLanguage.head)
      }
    }
    def getConstrain(lang: String = "en"): List[(String, String, String)] = {
      allCatch opt {
        adl.getOntology.getConstraintDefinitionsList.find(_.getLanguage == lang) match {
          case Some(ontology) ⇒ ontology.getDefinitions.map {
            o ⇒ (o.getCode, o.getText, o.getDescription)
          } toList
          case _ ⇒ List()
        }
      } getOrElse (List())
    }
    Ontology(getDefinition(lang) ::: getConstrain(lang))
  }

  // toString をoverride
  override def toString = super.toString +
    "\nOntology Language:\n\t" + ontologyLanguage.mkString(", ") +
    "\nOntology:\n" + getOntology("en").toString + "\n"

  /**
   * Conceptの詳細を取得
   * @return Conceptインスタンス
   */
  def getConcept = Concept(id, name, adl, getOntology("en"))
}
