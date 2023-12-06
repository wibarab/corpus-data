<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xtoks="http://acdh.oeaw.ac.at/xtoks"
                version="2.0"
                exclude-result-prefixes="#all">
   <xsl:output method="text"/>
   <xsl:include href="params.xsl"/>
   <xsl:import href="xsl/vert2txt.xsl"/>
   <xsl:template match="tei:annotationBlock">
      <xsl:sequence select="tei:structure(.)"/>
   </xsl:template>
   <xsl:template match="tei:u">
      <xsl:sequence select="tei:structure(.)"/>
   </xsl:template>
   <xsl:template match="tei:spanGrp">
      <xsl:sequence select="tei:structure(.)"/>
   </xsl:template>
   <xsl:template match="tei:span">
      <xsl:sequence select="tei:structure(.)"/>
   </xsl:template>
   <xsl:template match="tei:seg[@type = 'connected']">
      <xsl:sequence select="tei:structure(.)"/>
   </xsl:template>  
   <xsl:template name="noske-token">
      <xsl:value-of
         select="concat(string-join((normalize-space(normalize-unicode(., 'NFKC')), normalize-space(normalize-unicode(., 'NFD')), @xtoks:id[parent::xtoks:w], tei:sort-attrs(.)), '&#x9;'), '&#xA;')"
      />
   </xsl:template>
</xsl:stylesheet>
