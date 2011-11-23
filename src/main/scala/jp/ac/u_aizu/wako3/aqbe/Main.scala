package jp.ac.u_aizu.wako3.aqbe

import org.openehr.am.archetype.Archetype
import org.openehr.am.archetype.constraintmodel.CAttribute
import org.openehr.am.archetype.constraintmodel.CComplexObject
import org.openehr.am.archetype.constraintmodel.CMultipleAttribute
import org.openehr.am.archetype.constraintmodel.CObject
import org.openehr.am.archetype.ontology.ArchetypeTerm
import org.openehr.am.archetype.ontology.OntologyDefinitions
import org.openehr.am.openehrprofile.datatypes.text.CCodePhrase
import se.acode.openehr.parser.{ ADLParser ⇒ ArchetypeParser };
import jp.ac.u_aizu.wako3.concept._

object Main {
  def main(args: Array[String]) = {
    test3
  }
  def test2 = println(ConceptList(Settings.AdlPath).getHtml())
  def test3 = println(ConceptParser("openEHR-EHR-COMPOSITION.encounter.v1") mkString "\n")
  def test1 = {
    val adl = AdlParser(testList(15))
    println(adl.get)
    println("==================================")
    val concept = adl.get.asInstanceOf[ParsedAdl].getConcept
    concept.get match {
      case AdlObservation(name, dataList, stateList, protocolList) ⇒ {
        println("ADL NAME: " + name)
        println("------data------");
        dataList.foreach(println(_))
        println("------state------");
        stateList.foreach(println(_))
        println("------protocol------");
        protocolList.foreach(println(_))
      }
      case AdlComposition(name, contextList) ⇒ {
        println("ADL NAME: " + name)
        println("------context------");
        contextList.foreach(println(_))
      }
      case AdlItemTree(name, dataList) ⇒ {
        println("ADL NAME: " + name)
        println("------data------");
        dataList.foreach(println(_))
      }
      case AdlEvaluation(name, dataList) ⇒ {
        println("ADL NAME: " + name)
        println("------data------");
        dataList.foreach(println(_))
      }
      case AdlInstruction(name, dataList) ⇒ {
        println("ADL NAME: " + name)
        println("------data------");
        dataList.foreach(println(_))
      }
      case AdlAction(name, dataList) ⇒ {
        println("ADL NAME: " + name)
        println("------data------");
        dataList.foreach(println(_))
      }
      case AdlAdminEntry(name, dataList) ⇒ {
        println("ADL NAME: " + name)
        println("------data------");
        dataList.foreach(println(_))
      }
      case AdlSection(name) ⇒ {
        println("ADL NAME: " + name)
      }
      case _ ⇒ println("error!")
    }
    println("==================================")
  }
  val testList =
    "openEHR-EHR-ADMIN_ENTRY.admission.v1" :: //0
      "openEHR-EHR-ACTION.follow_up.v1" :: //1
      "openEHR-EHR-ACTION.imaging.v1" :: //2
      "openEHR-EHR-ACTION.intravenous_fluid_administration.v1" :: //3
      "openEHR-EHR-ACTION.medication.v1" :: //4
      "openEHR-EHR-ACTION.procedure.v1" :: //5
      "openEHR-EHR-ACTION.transfusion.v1" :: //6
      "openEHR-EHR-COMPOSITION.encounter.v1" :: //7
      "openEHR-EHR-COMPOSITION.medication_list.v1" :: //8
      "openEHR-EHR-COMPOSITION.prescription.v1" :: //9
      "openEHR-EHR-COMPOSITION.report.v1" :: //10
      "openEHR-EHR-EVALUATION.SOAP_Assessment_RCP.v3" :: //11
      "openEHR-EHR-INSTRUCTION.soap_plan_aspect.v5" :: //12
      "openEHR-EHR-ITEM_TREE.imaging.v1" :: //13
      "openEHR-EHR-ITEM_TREE.medication-vaccine.v1" :: //14
      "openEHR-EHR-ITEM_TREE.medication.v1" :: //15
      "openEHR-EHR-OBSERVATION.SOAP_Clerking8.v8" :: //16
      "openEHR-EHR-OBSERVATION.SOAP_RCP_History.v6" :: //17
      "openEHR-EHR-OBSERVATION.apgar.v1" :: //18
      "openEHR-EHR-OBSERVATION.blood_pressure.v1" :: //19
      "openEHR-EHR-OBSERVATION.body_mass_index.v1" :: //20
      "openEHR-EHR-OBSERVATION.body_temperature.v1" :: //21
      "openEHR-EHR-OBSERVATION.heart_rate.v1" :: //22
      "openEHR-EHR-OBSERVATION.lab_test-microbiology.v1" :: //23
      "openEHR-EHR-OBSERVATION.lab_test.v1" :: //24
      "openEHR-EHR-OBSERVATION.laboratory-glucose.v1" :: //25
      "openEHR-EHR-OBSERVATION.laboratory-hba1c.v1" :: //26
      "openEHR-EHR-OBSERVATION.soap_examinationsa2.v1draft" :: //27
      "openEHR-EHR-OBSERVATION.soap_investigations.v8" :: //28
      "openEHR-EHR-OBSERVATION.soap_rcp_examinations.v6" :: //29
      "openEHR-EHR-SECTION.conclusion.v1" :: //30
      "openEHR-EHR-SECTION.soap.v1" :: //31
      "openEHR-EHR-SECTION.vital_signs.v1" :: //32
      "openEHR-EHR-NOTHING.file_example" :: //33
      Nil
}
