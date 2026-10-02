<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xtoks="http://acdh.oeaw.ac.at/xtoks"
                version="2.0"
                exclude-result-prefixes="#all">
   <xsl:include href="wrapper_xtoks2vert.xsl"/>
   <xsl:template match="text()[parent::tei:span]" mode="extractTokens" priority="1">
      <xsl:value-of select="."/>
   </xsl:template>
   <!-- Do not use this deprecated location for the document ID. -->
   <xsl:template match="//tei:TEI/@xml:id" mode="doc-attributes" priority="1"/>
   <!-- In vicav_corpus documents the id is stored in this tei:idno element.
        It has the form ${VICAV-project}CorpusID -->
   <xsl:template match="//tei:idno[ends-with(@type, 'CorpusID')]" mode="doc-attributes">
      <xsl:attribute namespace="http://acdh.oeaw.ac.at/xtoks"
         name="id"
         select="."/></xsl:template>
</xsl:stylesheet>