<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:spanGrp"/>
    <xsl:template match="@xml:id[matches(.,'^\d')]">
        <xsl:attribute name="{name(.)}" select="concat(substring(parent::*/local-name(.),1,1),.)"/>
    </xsl:template>
    <!--   <xsl:template match="@who">
       <xsl:attribute name="who">WER-BIN-ICH</xsl:attribute>
   </xsl:template>     -->
    
</xsl:stylesheet>