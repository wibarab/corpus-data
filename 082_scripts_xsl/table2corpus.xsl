<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:_="https://wibarab.acdh.oeaw.ac.at"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="xs tei _ map"
                version="2.0">
    <xsl:output method="xml"
                indent="yes" />
    <!-- This stylesheet transforms the TEI representation of WIBARAB_Recordings.xlsx produed 
        by the TEIC's xlsxtotei.xsl (https://github.com/TEIC/Stylesheets/blob/dev/xlsx/xlsxtotei.xsl) 
        into the project's Corpus Header Document and included TEI Headers for the ELAN transcription.
        
        For the full conversion workflow cf. https://github.com/wibarab/corpus-data/tree/main/080_scripts_generic/080_01_ELAN2TEI
        
        INPUT: 080_scripts_generic/080_01_ELAN2TEI/data/WIBARAB_Recordings.xml
        OUTPUT: 102_derived_tei/wibarabCorpus.xml
        
        TODOs mentioned inline.
        
        Author: Daniel Schopper
        Created: 2022-03-10 (within the SHAWI project) -->
    <xsl:param name="pathToRecordings" />
    <xsl:param name="sp_pathToRecordingsXLSX" />
    <xsl:variable name="prefixDefs">
        <prefixDef ident="{$teiCorpusPrefix}"
                   matchPattern="^(.+)$"
                   replacementPattern="wibarabCorpus.xml#$1">
            <p>Private URIs using the <code>teiCorpusHeader</code> prefix are pointers to any element in the <ref target="wibarabCorpus.xml">WIBARAB teiCorpus document</ref>.</p>
        </prefixDef>
        <prefixDef ident="{$sharePrefix}"
                   matchPattern="^(.+)$"
                   replacementPattern="\\share17.univie.ac.at\orientalistik\WIBARAB\Recordings\*\*\$1.wav">
            <p>Private URIs using the <code>share</code> prefix are pointers to audio file residing on the WIBARAB network share.</p>
        </prefixDef>
        <prefixDef ident="{$vicavGeoListPrefix}"
                   matchPattern="^(.+)$"
                   replacementPattern="https://raw.githubusercontent.com/wibarab/featuredb/main/010_manannot/vicav_geodata.xml#$1">
            <p>Private URIs using the <code>geo</code> prefix are pointers to the <att>xml:id</att> attribute on a <gi>place</gi> element in <ref target="https://github.com/wibarab/featuredb/blob/main/010_manannot/vicav_geodata.xml">VICAV Geodata list</ref>.</p>
        </prefixDef>
        <prefixDef ident="{$dmpPrefix}"
                   matchPattern="^(.+)$"
                   replacementPattern="https://raw.githubusercontent.com/wibarab/featuredb/main/010_manannot/wibarab_dmp.xml#$1">
            <p>Private URIs using the <code>dmp</code> prefix are pointers to the <att>xml:id</att> attribute on an element in the <ref target="https://github.com/wibarab/featuredb/blob/main/010_manannot/wibarab_dmp.xml">WIBARAB DMP document.</ref>.</p>
        </prefixDef>
        <prefixDef ident="{$vicavZoteroGroupPrefix}"
                   matchPattern="^(.+)$"
                   replacementPattern="https://raw.githubusercontent.com/wibarab/featuredb/main/010_manannot/vicav_biblio_tei_zotero.xml#$1">
            <p>Private URIs using the <code>zotid</code> prefix are pointers to the <att>xml:id</att> attribute on a <gi>biblStruct</gi> element in the TEI export of the <ref target="https://www.zotero.org/groups/2165756/vicav/library">VICAV Zotero Group library</ref>.</p>
        </prefixDef>
        <prefixDef ident="{$sourcesPrefix}"
                   matchPattern="^(.+)$"
                   replacementPattern="https://raw.githubusercontent.com/wibarab/featuredb/main/010_manannot/wibarab_sources.xml#$1">
            <p>Private URIs using the <code>sources</code> prefix are pointers to the <att>xml:id</att> attribute on an element in the <ref target="https://github.com/wibarab/featuredb/blob/main/010_manannot/wibarab_sources.xml">WIBARAB list of sources</ref>.</p>
        </prefixDef>
    </xsl:variable>
    <xsl:variable name="teiCorpusPrefix">corpus</xsl:variable>
    <xsl:variable name="sharePrefix">share</xsl:variable>
    <xsl:variable name="vicavGeoListPrefix">geo</xsl:variable>
    <xsl:variable name="dmpPrefix">dmp</xsl:variable>
    <xsl:variable name="vicavZoteroGroupPrefix">zotid</xsl:variable>
    <xsl:variable name="sourcesPrefix">sources</xsl:variable>
    <xsl:variable name="cn"
                  as="map(xs:string, map(xs:string, xs:integer))">
        <xsl:map>
            <xsl:for-each select="//tei:table/tei:head">
                <xsl:map-entry key="xs:string(.)">
                    <xsl:map>
                        <xsl:for-each select="following-sibling::tei:row[@n='1'][1]/tei:cell[some $e in (tei:ptr/@target,.) satisfies normalize-space($e) ne '']">
                            <xsl:map-entry key="(tei:ptr/normalize-space(@target),normalize-space(.))[1]"
                                           select="xs:integer(position())" />
                        </xsl:for-each>
                    </xsl:map>
                </xsl:map-entry>
            </xsl:for-each>
        </xsl:map>
    </xsl:variable>
    <xsl:variable name="t_Speakers"
                  select="//tei:table[tei:head = 'Speakers']"
                  as="element(tei:table)" />
    <xsl:variable name="allSpeakers"
                  select="$t_Speakers//tei:row[position() gt 1][tei:cell[1] != '']"
                  as="element(tei:row)*" />
    <xsl:variable name="t_Speakers_in_Recordings"
                  select="//tei:table[tei:head = 'Speakers_in_Recordings']"
                  as="element(tei:table)" />
    <xsl:variable name="t_Subjects"
                  select="//tei:table[tei:head = 'Subjects']"
                  as="element(tei:table)" />
    <xsl:variable name="allSubjects"
                  select="$t_Subjects//tei:row[position() gt 1]"
                  as="element(tei:row)*" />
    <xsl:variable name="t_Subjects_in_Recordings"
                  select="//tei:table[tei:head = 'Subjects_in_Recordings']"
                  as="element(tei:table)" />
    <xsl:variable name="t_Team"
                  select="//tei:table[tei:head = 'Team']"
                  as="element(tei:table)" />
    <xsl:variable name="allTeam"
                  select="$t_Team//tei:row[position() gt 1][tei:cell[3] != '']"
                  as="element(tei:row)*" />
    <xsl:variable name="t_Places"
                  select="//tei:table[tei:head = 'Places']"
                  as="element(tei:table)" />
    <xsl:variable name="t_Campaigns"
                  select="//tei:table[tei:head = 'Campaigns']"
                  as="element(tei:table)" />
    <xsl:variable name="allNexts"
                  select="//tei:table[tei:head = 'Recordings']//tei:cell[$cn('Recordings')('Next')][.!='']" />
    <xsl:template match="/">
        <xsl:comment>THIS FILE WAS PROGRAMMATICALLY CREATED by table2corpus.xsl on/at <xsl:value-of select="current-dateTime()" />
    </xsl:comment>
    <xsl:result-document method="json"
                         href="table_cell_num_mapping.json">
        <xsl:sequence select="$cn" />
    </xsl:result-document>
    <xsl:apply-templates select="//tei:table[tei:head = 'Recordings']" />
</xsl:template>
<xsl:function name="_:ID"
              as="xs:string">
    <xsl:param name="value"
               as="element(tei:cell)" />
    <xsl:value-of select="replace($value,'[^A-Za-z]','')" />
</xsl:function>
<xsl:function name="_:sortKey"
              as="xs:string">
    <xsl:param name="value"
               as="element(tei:cell)" />
    <xsl:value-of select="replace(lower-case($value),'^(a|the)\s','')" />
</xsl:function>
<xsl:function name="_:personReferenceByName"
              as="element(tei:person)?">
    <xsl:param name="persName"
               as="xs:string" />
    <xsl:variable name="tei:row"
                  select="($allTeam[tei:cell[$cn('Team')('persName')] = $persName], $allSpeakers[tei:cell[$cn('Speakers')('Speaker')] = $persName])[1]" />
    <xsl:apply-templates select="$tei:row"
                         mode="teiInstanceDoc" />
</xsl:function>
<xsl:template name="publicationStmt">
    <xsl:param name="textID" />
    <publicationStmt>
        <publisher ref="https://ror.org/03anc3s24">Austrian Academy of Sciences</publisher>
        <publisher ref="https://ror.org/03prydq77">University of Vienna</publisher>
        <distributor ref="https://ror.org/028bsh698">Austrian Center for Digital Humanities and Cultural Heritage</distributor>
        <date when="????-??-??">TODO Set publication date here</date>
        <address>
            <addrLine>Bäckerstraße 13</addrLine>
            <addrLine>1010 Vienna</addrLine>
            <addrLine>Austria</addrLine>
        </address>
        <availability status="free">
            <licence target="https://creativecommons.org/licenses/by/4.0/">CC BY 4.0</licence>
        </availability>
        <xsl:if test="$textID != ''">
            <idno type="WIBARABCorpusID">
                <xsl:value-of select="$textID" />
            </idno>
        </xsl:if>
    </publicationStmt>
</xsl:template>
<xsl:template name="titleStmt">
    <xsl:param name="textID" />
    <xsl:param name="recordingPerson" />
    <xsl:param name="recordingPersonID" />
    <xsl:param name="transcribingPerson" />
    <xsl:param name="transcriptionChecker" />
    <xsl:param name="translator" />
    <xsl:param name="translationChecker" />
    <titleStmt>
        <xsl:if test="$textID != ''">
            <title level="a">
                <xsl:value-of select="$textID" />
            </title>
        </xsl:if>
        <title level="s">WIBARAB Corpus</title>
        <xsl:choose>
            <xsl:when test="$textID != ''">
                <!-- <xsl:apply-templates select="."
                                     mode="respStmtInstanceDoc" /> -->
                <!-- which prefix to use? corpus prefix or dmp prefix -->
                <respStmt>
                    <persName ref="{$dmpPrefix}:SP">Stephan Procházka</persName>
                    <resp>principal</resp>
                </respStmt>
                <respStmt>
                    <persName ref="{$dmpPrefix}:{$recordingPersonID}">
                        <xsl:value-of select="$recordingPerson" />
                    </persName>
                    <resp>recording</resp>
                </respStmt>
                <xsl:if test="$transcribingPerson != ''">
                <respStmt>
                    <persName ref="{$dmpPrefix}:{_:personReferenceByName($transcribingPerson)}">
                        <xsl:value-of select="$transcribingPerson"/>
                    </persName>
                    <resp>transcription</resp>
                </respStmt>
            </xsl:if>
            <xsl:if test="$transcriptionChecker != ''">
                <respStmt>
                    <persName ref="{$dmpPrefix}:{_:personReferenceByName($transcriptionChecker)}">
                        <xsl:value-of select="$transcriptionChecker"/>
                    </persName>
                    <resp>transcription check</resp>
                </respStmt>
            </xsl:if>
            <xsl:if test="$translator != ''">
                <respStmt>
                    <persName ref="{$dmpPrefix}:{_:personReferenceByName($translator)}">
                        <xsl:value-of select="$translator"/>
                    </persName>
                    <resp>translation</resp>
                </respStmt>
            </xsl:if>
            <xsl:if test="$translationChecker != ''">
                <respStmt>
                    <persName ref="{$dmpPrefix}:{_:personReferenceByName($translationChecker)}">
                        <xsl:value-of select="$translationChecker"/>
                    </persName>
                    <resp>translation check</resp>
                </respStmt>
            </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <!-- TODO add fields from Recordings table -->
                <xsl:apply-templates select="$allTeam"
                                     mode="respStmtCorpusDoc" />
            </xsl:otherwise>
        </xsl:choose>
        <funder>Funded by the <orgName ref="https://ror.org/0472cxd90">European Research Council</orgName> under the Grant Agreement <idno type="projectNumber">101020127</idno>.</funder>
    </titleStmt>
</xsl:template>
<!-- The /Recordings/ table is converted to our TEI Corpus document -->
<xsl:template match="tei:table[tei:head = 'Recordings']">
    <teiCorpus>
        <teiHeader>
            <fileDesc>
                <xsl:call-template name="titleStmt" />
                <xsl:call-template name="publicationStmt" />
                <sourceDesc>
                    <p>Derived from <ptr target="{$sp_pathToRecordingsXLSX}" /> via xlsxtotei and table2corpus.xsl</p>
                </sourceDesc>
            </fileDesc>
            <encodingDesc>
                <classDecl>
                    <taxonomy>
                        <xsl:for-each select="$allSubjects[tei:cell[$cn('Subjects')('Label')] != '']">
                            <xsl:sort select="_:sortKey(tei:cell[$cn('Subjects')('Label')])" />
                            <xsl:variable name="subjectID"
                                          select="_:ID(tei:cell[1])" />
                            <category xml:id="{$subjectID}"
                                      n="{tei:cell[$cn('Subjects')('Label')]}">
                                <catDesc>
                                    <xsl:value-of select="(tei:cell[$cn('Subjects')('Definition')][. != ''],'TODO ADD DESCRIPTION in Subjects table!')[1]" />
                                </catDesc>
                            </category>
                        </xsl:for-each>
                    </taxonomy>
                </classDecl>
                <listPrefixDef>
                    <xsl:sequence select="$prefixDefs" />
                </listPrefixDef>
            </encodingDesc>
            <profileDesc>
                <particDesc>
                    <listPerson>
                        <head>All Speakers in the WIBARAB Corpus</head>
                        <xsl:apply-templates select="$allSpeakers"
                                             mode="teiCorpusDoc" />
                    </listPerson>
                </particDesc>
            </profileDesc>
        </teiHeader>
        <!-- replaced by DMP document -->
        <!-- <standOff>
                <listPerson>
                    <head>Project Team</head>
                    <xsl:apply-templates select="$allTeam" mode="teiCorpusDoc"/>
                </listPerson>
            </standOff> -->
        <xsl:apply-templates select="tei:row[position() gt 1][tei:cell[1] != '']" />
    </teiCorpus>
</xsl:template>
<xsl:template match="tei:table[tei:head = 'Recordings']/tei:row[normalize-space(tei:cell[$cn('Recordings')('Rec. person')]) ne '']"
              priority="0">
    <xsl:variable name="textID"
                  select="tei:cell[$cn('Recordings')('Text')]" />
    <!-- find all rows with the matching text ID and take "the other" cell of the row, which is the speaker ID -->
    <xsl:variable name="speakerIDs"
                  select="$t_Speakers_in_Recordings//tei:row[tei:cell = $textID]/tei:cell[. != $textID]" />
    <xsl:variable name="speakers_in_recording"
                  select="$allSpeakers[tei:cell[$cn('Recordings')('Text')] = $speakerIDs]"
                  as="element(tei:row)*" />
    <!--  -->
    <xsl:variable name="subjectIDs"
                  select="$t_Subjects_in_Recordings//tei:row[tei:cell = $textID]/tei:cell[. != $textID]" />
    <xsl:variable name="subjects_in_recording"
                  select="$allSubjects[tei:cell[$cn('Subjects')('Label')] = $subjectIDs]"
                  as="element(tei:row)*" />
    <xsl:variable name="recordingPerson"
                  select="normalize-space(tei:cell[$cn('Recordings')('Rec. person')])" />
    <xsl:variable name="recordingPersonID"
                  select="_:personReferenceByName($recordingPerson)" />
    <xsl:variable name="transcribingPerson" select="normalize-space(tei:cell[$cn('Recordings')('transcribed by')])"/>
    <xsl:variable name="transcriptionChecker" select="normalize-space(tei:cell[$cn('Recordings')('transcription checked by')])"/>
    <xsl:variable name="translator" select="normalize-space(tei:cell[$cn('Recordings')('translated by')])"/>
    <xsl:variable name="translationChecker" select="normalize-space(tei:cell[$cn('Recordings')('translation checked by')])"/>
    <!-- place -->
    <xsl:variable name="placeName"
                  select="tei:cell[$cn('Recordings')('Place')]" />
    <xsl:variable name="placeID"
                  select="$t_Places//tei:row[tei:cell[$cn('Places')('PlaceName')] = $placeName]/tei:cell[$cn('Places')('ID')]" />
    <!-- path to Audio files -->
    <xsl:variable name="audioFilename"
                  select="tei:cell[$cn('Recordings')('Trascribed Audio-file')]" />
    <xsl:variable name="fullPath"
                  select="$pathToRecordings" />
    <xsl:variable name="campaignName"
                  select="tei:cell[$cn('Recordings')('Campaign')]" />
    <xsl:variable name="campaign"
                  select="$t_Campaigns//tei:row[tei:cell[$cn('Campaigns')('Campaign')]=$campaignName]" />
    <xsl:variable name="campaignID"
                  select="$campaign/tei:cell[$cn('Campaigns')('ID')]" />
    <TEI>
        <xsl:if test="tei:cell[$cn('Recordings')('Next')]!=''">
            <xsl:attribute name="next">
                <xsl:value-of select="concat(tei:cell[$cn('Recordings')('Next')],'.xml')" />
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$textID = $allNexts">
            <!-- get ID of the text where the current text is indicated to be the next one -->
            <xsl:variable name="prevID"
                          select="$allNexts[. = $textID]/../tei:cell[$cn('Recordings')('Text')]" />
            <xsl:attribute name="prev">
                <xsl:value-of select="concat($prevID,'.xml')" />
            </xsl:attribute>
        </xsl:if>
        <teiHeader>
            <fileDesc>
                <xsl:call-template name="titleStmt">
                    <xsl:with-param name="textID"
                                    select="$textID" />
                    <xsl:with-param name="recordingPersonID"
                                    select="$recordingPersonID" />
                    <xsl:with-param name="recordingPerson"
                                    select="$recordingPerson" />
                    <xsl:with-param name="transcribingPerson"
                                    select="$transcribingPerson" />
                    <xsl:with-param name="transcriptionChecker"
                                    select="$transcriptionChecker" />
                    <xsl:with-param name="translator"
                                    select="$translator" />
                    <xsl:with-param name="translationChecker"
                                    select="$translationChecker" />
                </xsl:call-template>
                <xsl:call-template name="publicationStmt">
                    <xsl:with-param name="textID"
                                    select="$textID" />
                </xsl:call-template>
                <sourceDesc>
                    <!-- TODO reference source audio file to match with ELAN export. -->
                    <recordingStmt>
                        <!-- TODO parse duration and date -->
                        <recording dur-iso="{tei:cell[$cn('Recordings')('Length')]}"
                                   type="audio">
                            <xsl:choose>
                                <xsl:when test="tei:cell[$cn('Recordings')('Date')] != ''">
                                    <date when="{_:excelSerialToISO( tei:cell[$cn('Recordings')('Date')])}" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:comment>recording date unknown</xsl:comment>
                                </xsl:otherwise>
                            </xsl:choose>
                            <respStmt>
                                <resp>recording</resp>
                                <persName ref="{$teiCorpusPrefix}:{$recordingPersonID}">
                                    <xsl:value-of select="$recordingPerson" />
                                </persName>
                            </respStmt>
                            <!-- TODO The audio files on the share need to be re-organised to match the replacementPattern in the header -->
                            <xsl:if test="$audioFilename!=''">
                                <media url="{$sharePrefix}:{$audioFilename}"
                                       mimeType="audio/wav"
                                       type="master" />
                            </xsl:if>
                            <xsl:if test="$campaignName != ''">
                                <p>Recorded during <xsl:value-of select="$campaignName" />
                            </p>
                        </xsl:if>
                    </recording>
                </recordingStmt>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
            <listPrefixDef>
                <xsl:sequence select="$prefixDefs" />
            </listPrefixDef>
        </encodingDesc>
        <profileDesc>
            <particDesc>
                <listPerson>
                    <head>Speakers in <xsl:value-of select="$textID" />
                </head>
                <xsl:if test="count($speakers_in_recording) eq 0">
                    <xsl:comment>TODO Add Speakers to Speakers_in_Recording Table</xsl:comment>
                </xsl:if>
                <xsl:for-each select="$speakers_in_recording">
                    <xsl:apply-templates select="."
                                         mode="teiInstanceDoc" />
                </xsl:for-each>
            </listPerson>
        </particDesc>
        <!-- TODO find ID -->
        <!-- TODO fetch additional metadata from place list -->
        <settingDesc corresp="{$sourcesPrefix}:{$campaignID}">
            <xsl:choose>
                <xsl:when test="$placeName != ''">
                    <setting>
                        <placeName sameAs="{$vicavGeoListPrefix}:{$placeID}">
                            <xsl:value-of select="$placeName" />
                        </placeName>
                    </setting>
                </xsl:when>
                <xsl:otherwise>
                    <p>No place of Recording provided.</p>
                </xsl:otherwise>
            </xsl:choose>
        </settingDesc>
        <textClass>
            <xsl:for-each select="$subjects_in_recording">
                <xsl:sort select="_:sortKey(tei:cell[1])" />
                <xsl:apply-templates select="."
                                     mode="teiInstanceDoc" />
            </xsl:for-each>
        </textClass>
    </profileDesc>
</teiHeader>
<text>
    <body>
        <p>
            <xsl:comment>The text of this recording will be added after transcription has finished.</xsl:comment>
        </p>
    </body>
</text>
</TEI>
</xsl:template>
<xsl:function name="_:excelSerialToISO"
              as="xs:date">
    <xsl:param name="serial"
               required="yes"
               as="xs:int" />
    <xsl:sequence select="xs:date('1899-12-30') + xs:dayTimeDuration('P'||$serial||'D')" />
</xsl:function>
<xsl:template match="tei:table[tei:head = 'Recordings']/tei:row"
              priority="-2" />
<!-- don't process rows that have no Rec. Person filled in -->
<xsl:template match="tei:table[tei:head = 'Subjects']/tei:row[tei:cell[1] != '']">
    <xsl:variable name="subjectID" />
    <keyword>
        <term>
            <xsl:value-of select="tei:cell[1]" />
        </term>
    </keyword>
</xsl:template>
<xsl:template match="tei:table[tei:head = 'Speakers']/tei:row[tei:cell[1] != '']"
              mode="teiCorpusDoc">
    <!-- mode = what is the context of this run:
            * "teiCorpusDoc": this generates the master list of speakers in the teiCorpus  
            * "teiInstanceDoc": this generates the list of speakers in one TEI instance, 
            thus not include all details but a @sameAs attribute pointing to the corpusHeader -->
    <person xml:id="{tei:cell[1]}"
            sex="{tei:cell[2]}" age="{tei:cell[4]}">
        <idno>
            <xsl:value-of select="tei:cell[1]" />
        </idno>
        <xsl:call-template name="parseBirth">
            <xsl:with-param name="yearOfBirth"
                            select="tei:cell[3]" />
            <xsl:with-param name="placeOfOrigin"
                            select="tei:cell[7]" />
            <xsl:with-param name="ageGroupComment" select="tei:cell[5]"/>
        </xsl:call-template>
        <xsl:if test="tei:cell[6] != ''">
            <langKnowledge>
                <xsl:for-each select="tokenize(tei:cell[6], ',')">
                    <langKnown tag="{.}" />
                </xsl:for-each>
            </langKnowledge>
        </xsl:if>
        <xsl:if test="tei:cell[9] != 'N/A'">
            <xsl:for-each select="tokenize(tei:cell[9], ',')">
                <ptr type="participatedIn" target="#{normalize-space(.)}"/>
            </xsl:for-each>
        </xsl:if>
        <!-- Notes potentially contain internal information, so we ignore them for the moment. -->
        <!-- <note><xsl:value-of select="tei:cell[8]"/></note> -->
    </person>
</xsl:template>
<xsl:template name="parseBirth">
    <xsl:param name="yearOfBirth" />
    <xsl:param name="placeOfOrigin" />
    <xsl:param name="ageGroupComment" />
    <xsl:choose>
        <xsl:when test="matches($yearOfBirth,'^\d+$')">
            <birth>
                <date when="{$yearOfBirth}">
                    <xsl:value-of select="$yearOfBirth" />
                </date>
                <xsl:if test="$placeOfOrigin != ''">
                    <placeName>
                        <xsl:value-of select="$placeOfOrigin" />
                    </placeName>
                </xsl:if>
                <xsl:if test="$ageGroupComment != ''">
                    <note>
                        <xsl:value-of select="$ageGroupComment" />
                    </note>
                </xsl:if>
            </birth>
        </xsl:when>
        <xsl:when test="matches($yearOfBirth, '^\d{4,4}s')">
            <xsl:variable name="int"
                          select="xs:integer(substring($yearOfBirth,1,4))" />
            <birth>
                <date notBefore="{$int}"
                      notAfter="{$int+9}">
                    <xsl:value-of select="$yearOfBirth" />
                </date>
                <xsl:if test="$placeOfOrigin != ''">
                    <placeName>
                        <xsl:value-of select="$placeOfOrigin" />
                    </placeName>
                </xsl:if>
            </birth>
        </xsl:when>
        <xsl:when test="$yearOfBirth = '' and $placeOfOrigin != ''">
            <birth>
                <xsl:comment>no information on birth date</xsl:comment>
                <placeName>
                    <xsl:value-of select="$placeOfOrigin" />
                </placeName>
            </birth>
        </xsl:when>
        <xsl:when test="$yearOfBirth != '' and $placeOfOrigin != ''">
            <xsl:comment>no information on birth date or origin</xsl:comment>
        </xsl:when>
        <xsl:otherwise>
            <birth>
                <xsl:comment>Could not parse of birth date</xsl:comment>
                <date>
                    <xsl:value-of select="$yearOfBirth" />
                </date>
                <xsl:if test="$placeOfOrigin != ''">
                    <placeName>
                        <xsl:value-of select="$placeOfOrigin" />
                    </placeName>
                </xsl:if>
            </birth>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
<xsl:template match="tei:table[tei:head = 'Speakers']/tei:row[tei:cell[1] != '']"
              mode="teiInstanceDoc">
    <!-- mode = what is the context of this run:
            * "teiCorpusDoc": this generates the master list of speakers in the teiCorpus  
            * "teiInstanceDoc": this generates the list of speakers in one TEI instance, 
            thus not include all details but a @sameAs attribute pointing to the corpusHeader -->
    <person sameAs="{$teiCorpusPrefix}:{tei:cell[1]}">
        <idno>
            <xsl:value-of select="tei:cell[1]" />
        </idno>
    </person>
</xsl:template>
<xsl:template match="tei:table[tei:head = 'Team']/tei:row[tei:cell[$cn('Team')('http://www.w3.org/XML/1998/namespace.Attribute:id')] != '']"
              mode="teiCorpusDoc">
    <!-- mode = what is the context of this run:
            * "teiCorpusDoc": this generates the master list of team members in the teiCorpus
            * "respStmts: genereates a list of respStmts pointing to the list of team members 
            * "teiInstanceDoc": this generates the list of team members in one TEI instance, 
            thus not include all details but a @sameAs attribute pointing to the corpusHeader -->
    <xsl:param name="mode" />
    <person xml:id="{tei:cell[$cn('Team')('http://www.w3.org/XML/1998/namespace.Attribute:id')]}">
        <persName>
            <xsl:value-of select="tei:cell[$cn('Team')('persName')]" />
        </persName>
        <state type="projectRole">
            <desc>
                <xsl:value-of select="tei:cell[$cn('Team')('Attribute:role')]" />
            </desc>
        </state>
        <idno type="URI"
              subtype="ORCID">
            <xsl:choose>
                <xsl:when test="tei:cell[$cn('Team')('ORCID')] != ''">
                    <xsl:value-of select="concat('https://orcid.org/',tei:cell[$cn('Team')('ORCID')])" />
                </xsl:when>
                <xsl:otherwise>No ORCID provided.</xsl:otherwise>
            </xsl:choose>
        </idno>
        <affiliation>
            <xsl:value-of select="tei:cell[$cn('Team')('affiliation.Element:Text')]" />
        </affiliation>
        <!-- ignore because might contain internal information -->
        <!-- <note><xsl:value-of select="tei:cell[$cn('Team')('note')]"/></note> -->
    </person>
</xsl:template>
<!-- old code -->
<!-- <xsl:template match="tei:table[tei:head = 'Team']/tei:row[tei:cell[$cn('Team')('http://www.w3.org/XML/1998/namespace.Attribute:id')]!='']"
              mode="respStmtInstanceDoc"> -->
<!-- mode = what is the context of this run:
            * "teiCorpusDoc": this generates the master list of team members in the teiCorpus 
            * "teiInstanceDoc": this generates the list of team members in one TEI instance, 
            * "respStmtsCorpusDoc: genereates a list of respStmts in the TEI Corpus Header
            * "respStmtsInstanceDoc: genereates a list of respStmts pointing to the list of team members in the TEI Corpus
            thus not include all details but a @sameAs attribute pointing to the corpusHeader -->
<!-- <xsl:param name="mode" />
    <respStmt>
        <persName ref="{$dmpPrefix}:{tei:cell[$cn('Team')('http://www.w3.org/XML/1998/namespace.Attribute:id')]}">
            <xsl:value-of select="tei:cell[$cn('Team')('persName')]" />
        </persName>
        <resp>
            <xsl:value-of select="tei:cell[$cn('Team')('Attribute:role')]" />
        </resp>
    </respStmt>
</xsl:template> -->
<!-- END old code -->
<xsl:template match="tei:table[tei:head = 'Team']/tei:row[tei:cell[$cn('Team')('http://www.w3.org/XML/1998/namespace.Attribute:id')] != '']"
              mode="respStmtCorpusDoc">
    <!-- mode = what is the context of this run:
            * "teiCorpusDoc": this generates the master list of team members in the teiCorpus
            * "respStmts: genereates a list of respStmts pointing to the list of team members in the TEI Corpus 
            * "teiInstanceDoc": this generates the list of team members in one TEI instance, 
            thus not include all details but a @sameAs attribute pointing to the corpusHeader -->
    <xsl:param name="mode" />
    <respStmt>
        <persName ref="{$dmpPrefix}:{tei:cell[$cn('Team')('http://www.w3.org/XML/1998/namespace.Attribute:id')]}">
            <xsl:value-of select="tei:cell[1]" />
        </persName>
        <resp>
            <xsl:value-of select="tei:cell[$cn('Team')('Attribute:role')]" />
        </resp>
    </respStmt>
</xsl:template>
<xsl:template match="tei:table[tei:head = 'Team']/tei:row[tei:cell[$cn('Team')('http://www.w3.org/XML/1998/namespace.Attribute:id')] != '']"
              mode="teiInstanceDoc">
    <!-- mode = what is the context of this run:
            * "teiCorpusDoc": this generates the master list of team members in the teiCorpus
            * "respStmts: genereates a list of respStmts pointing to the list of team members 
            * "teiInstanceDoc": this generates the list of team members in one TEI instance, 
            thus not include all details but a @sameAs attribute pointing to the corpusHeader -->
    <person sameAs="{$teiCorpusPrefix}:{tei:cell[$cn('Team')('http://www.w3.org/XML/1998/namespace.Attribute:id')]}">
        <xsl:value-of select="tei:cell[$cn('Team')('http://www.w3.org/XML/1998/namespace.Attribute:id')]" />
    </person>
</xsl:template>
<xsl:template match="tei:table[tei:head = 'Subjects']/tei:row[tei:cell[1] != '']"
              mode="teiInstanceDoc">
    <!-- mode = what is the context of this run:
            * "teiCorpusDoc": this generates the master list of speakers in the teiCorpus  
            * "teiInstanceDoc": this generates the list of speakers in one TEI instance, 
            thus not include all details but a @sameAs attribute pointing to the corpusHeader -->
    <catRef target="{$teiCorpusPrefix}:{_:ID(tei:cell[1])}" />
</xsl:template>
</xsl:stylesheet>