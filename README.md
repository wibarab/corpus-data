# WIBARAB Transcription Repository

This git repository hosts the transcription data of the project *What is Bedouin-Type Arabic? (ERC Advanced Grant 101020127)* (October 2021 to September 2026).

Principal Investigator: Stephan Procházka (University of Vienna)     
Cooperation Partner: Charly Mörth (Austrian Academy of Sciences)     

See <https://wibarab.acdh.oeaw.ac.at/> for more information

Contact us at [wibarab@oeaw.ac.at](mailto:wibarab@oeaw.ac.at) or follow us on [Twitter](https://twitter.com/wibarab).


## Status

**THIS IS PRELIMINARY DATA AND COPYRIGHTED MATERIAL!**

If you want to use any material in this repository please contact PI Stephan Procházka (University of Vienna).

This will change at the end of the project.

## Deploy data changes

To deploy changes to this data please follow the [wibarab-data README](https://github.com/wibarab/wibarab-data?tab=readme-ov-file#re-deploy-wibarab-website)

## Directory Structure

| Directory             | Content                    | Remarks                                                                                                                                                                                                                     |
| --------------------- | -------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `001_src`             | Original sources           | Source documents (e.g. raw transcriptions)                                                                                                                                                                                  |
| `080_scripts_generic` | Conversion Scripts         | mostly the ELAN2TEI conversion script (implemented in Python) which generates the initial TEI data prior to tokenization based on the ELAN transcription documents in [122_elan](122_elan)                                  |
| `082_scripts_xsl`     | XSLT scripts               | XSLT scripts                                                                                                                                                                                                                |
| `103_tei_w`     | TEI-XML with tokens          | This is where ELAN2TEI puts its output. **Re-running TEI2ELAN will overwrite all content in this directory, so do not do any manual changes here but copy the file to `010_manannot` beforehand.**  |
| `010_manannot`        | manually annotated TEI-XML | Tokenized TEI documents from `103_tei_w` which are manually annotated.                                                                                                                                                                       |
| `802_tei_odd`         | TEI customization (ODD)    | This is the source of truth for the SHAWI Schema and the HTML documentation generated from it.                                                                                                                              |
| `130_vert_plain`       | NoSketch Engine Verticals  | NoSketch Engine text verticals                                                                                                                                                                                                     |
| `803_RNG-schematron`  | Schemas                    | derived from the ODD in `802_tei_odd`                                                                                                                                                                                       |
| `804_xsd`  | Schemas                    | derived from the ODD in `802_tei_odd` |
| `850_docs`            | Documentation              | Further data documentation, esp. the HTML documentation of the ODD                                                                                                                                                          |


The directories `css`, `html`, `js` and `xsl` are used by the TEI Enricher.

## Other data locations

* Master files of the **audio recordings** are stored on the project's network share at the University of Vienna
* the **metadata spreadsheet** is [hosted on Sharepoint](https://oeawacat.sharepoint.com/:x:/r/sites/ACDH-CH_p_WIBARAB_BedoinTypeArabicNomadicSedentaryPeopleMidd/_layouts/15/Doc.aspx?sourcedoc=%7BA3E7E3BC-BFBC-4FB8-86A2-A2701F3AD2C9%7D&file=WIBARAB_Fieldwork%20Recording%20Registers.xlsx&action=default&mobileredirect=true).

## General Workflow

NB The workflow will be described in due manner but will be very similar to the one described in the [*SHAWI Data Processing and Curation* Document](https://oeawacat.sharepoint.com/:w:/r/sites/ACDH-CH_p_ShawiTypeArabicDialects_Shawi/_layouts/15/Doc.aspx?sourcedoc=%7B2C46C1F7-110E-4BB9-981D-A068086B9767%7D&file=Data_Curation_and_Processing_Handbook_Template.docx&action=default&mobileredirect=true&cid=17912ea5-8f1f-4b88-ba45-43b73373ecfd)

The following steps happen _before_ data is ingested into this repository:

* **fieldwork (recording audio etc.)** – The recordings so far cover only material collected in previous campaigns
* **campaign** metadata is added in the "sources" document in the WIBARAB featuredb repository
* **collecting metadata:** – This is collected at curated in [the metadata spreadsheet].

Workflow steps reflected in the data in this repository:

* **Transcription and translation** – Curators segment the audio recordings into sensible sets of "utterances" and transcribe and translate them using [ELAN](https://archive.mpi.nl/tla/elan). When transcription has finished, the curator adds the ELAN document(s) to `122_elan` and pushes the changes to git.
* **Tokenization**  This push triggers the **[ELAN2TEI conversion workflow](elan2tei)** which takes all *.eaf files in `122_ELAN` and transforms them into tokenized standalone TEI documents, storing them under `103_tei_w`. Additionally, a TEI Corpus file is generated which includes corpus level metadata and controlled vocabularies. 
* **Annotation** After transformation to TEI, curators annotate the texts using the TEI\_enricher and store the results under ``010_manannot``. 
* **Conversion to NoSke Verticals** During the tokenization process, a NoSke-compatible vertical is created which incorporates the annotations found in ``010_manannot` .
* **Deployment** The data is automatically deployed to an instance of the NoSketchEngine corpus query engine.

