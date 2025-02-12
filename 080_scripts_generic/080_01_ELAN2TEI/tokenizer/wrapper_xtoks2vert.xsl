<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xtoks="http://acdh.oeaw.ac.at/xtoks"
                version="2.0"
                exclude-result-prefixes="#all">
   <xsl:include href="params.xsl"/>
   <xsl:include href="xsl/xtoks2vert.xsl"/>
   <xsl:template match="tei:annotationBlock" mode="extractTokens">
      <xsl:variable name="content" as="item()*">
         <xsl:apply-templates mode="#current"/>
      </xsl:variable>
      <xsl:if test="exists($content)">
         <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:sequence select="$content"/>
         </xsl:copy>
      </xsl:if>
   </xsl:template>
   <xsl:template match="tei:u" mode="extractTokens">
      <xsl:variable name="content" as="item()*">
         <xsl:apply-templates mode="#current"/>
      </xsl:variable>
      <xsl:if test="exists($content)">
         <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:sequence select="$content"/>
         </xsl:copy>
      </xsl:if>
   </xsl:template>
   <xsl:template match="tei:spanGrp" mode="extractTokens">
      <xsl:variable name="content" as="item()*">
         <xsl:apply-templates mode="#current"/>
      </xsl:variable>
      <xsl:if test="exists($content)">
         <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:sequence select="$content"/>
         </xsl:copy>
      </xsl:if>
   </xsl:template>
   <xsl:template match="tei:span" mode="extractTokens">
      <xsl:variable name="content" as="item()*">
         <xsl:apply-templates mode="#current"/>
      </xsl:variable>
      <xsl:if test="exists($content)">
         <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:sequence select="$content"/>
         </xsl:copy>
      </xsl:if>
   </xsl:template>
   <xsl:template match="tei:seg[@type = 'connected']" mode="extractTokens">
      <xsl:variable name="content" as="item()*">
         <xsl:apply-templates mode="#current"/>
      </xsl:variable>
      <xsl:if test="exists($content)">
         <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:sequence select="$content"/>
         </xsl:copy>
      </xsl:if>
   </xsl:template>
   <xsl:template match="//tei:title[@level='a']" mode="doc-attributes">
      <xsl:attribute namespace="http://acdh.oeaw.ac.at/xtoks"
                     name="id"
                     select="string-join(//tei:title[@level='a']/normalize-space(), ' ')"/>
   </xsl:template>
   <xsl:template match="//tei:sourceDesc/tei:recording/tei:media/@url"
                 mode="doc-attributes">
      <xsl:attribute namespace="http://acdh.oeaw.ac.at/xtoks"
                     name="audio"
                     select="string-join(//tei:sourceDesc/tei:recording/tei:media/@url/normalize-space(), ' ')"/>
   </xsl:template>
   <xsl:template match="//tei:textClass/tei:catRef/@target" mode="doc-attributes">
      <xsl:attribute namespace="http://acdh.oeaw.ac.at/xtoks"
                     name="topic"
                     select="string-join(//tei:textClass/tei:catRef/@target/normalize-space(), ' ')"/>
   </xsl:template>
   <xsl:template match="//tei:recording//tei:persName/@ref" mode="doc-attributes">
      <xsl:attribute namespace="http://acdh.oeaw.ac.at/xtoks"
                     name="researcher"
                     select="string-join(//tei:recording//tei:persName/@ref/normalize-space(), ' ')"/>
   </xsl:template>
   <xsl:template match="//tei:recording/tei:p/tei:ref" mode="doc-attributes">
      <xsl:attribute namespace="http://acdh.oeaw.ac.at/xtoks"
                     name="campaign"
                     select="string-join(//tei:recording/tei:p/tei:ref/normalize-space(), ' ')"/>
   </xsl:template>
   <xsl:template match="//tei:settingDesc/tei:place" mode="doc-attributes">
      <xsl:attribute namespace="http://acdh.oeaw.ac.at/xtoks"
                     name="geo"
                     select="string-join(//tei:settingDesc/tei:place/normalize-space(), ' ')"/>
   </xsl:template>
   <xsl:template match="//tei:particDesc//tei:person" mode="doc-attributes">
      <xsl:attribute namespace="http://acdh.oeaw.ac.at/xtoks"
                     name="speakers"
                     select="string-join(//tei:particDesc//tei:person/normalize-space(), ' ')"/>
   </xsl:template>
</xsl:stylesheet>
