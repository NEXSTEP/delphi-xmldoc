<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

        <xsl:variable name="configurations" select="document('configurations.xml')/configuration" />
        <xsl:variable name="noteConfigurations" select="$configurations/notes" />
        <xsl:variable name="sectionConfigurations" select="$configurations/sections" />
        <xsl:variable name="typeConfigurations" select="$configurations/types" />

	<xsl:template name="html-head">
		<xsl:param name="title" />
		<head>
			<meta name="generator" content="NEXSTEP.XMLDoc" />
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			<title>
				<xsl:value-of select="$title" />
			</title>
			<link rel="stylesheet" type="text/css" href="css/xmldoc.css" />
			<script src="js/xmldoc.js" type="text/javascript" />
		</head>
	</xsl:template>

	<xsl:template name="title-row">
		<xsl:param name="type-name" />
		<div id="nsbanner">
			<div id="bannerrow1">
				<table class="bannerparthead" cellspacing="0">
					<tr id="hdr">
						<td class="runninghead" nowrap="true">
							<!--xsl:value-of select="$doc-title" /--> NEXSTEP.CIS.Classes
						</td>
						<td class="product" nowrap="true"></td>
					</tr>
				</table>
			</div>
			<div id="TitleRow">
				<h1 class="dtH1">
					<xsl:value-of select="$type-name" />
				</h1>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="create_page">
		<xsl:param name="name" />
		<xsl:param name="mode" />

		<xsl:result-document href="{translate($name, &quot;'`&quot;, '_')}">
			<xsl:choose>
				<xsl:when test="$mode='type'">			
					<xsl:apply-templates select="." mode="type"/>
				</xsl:when>
				<xsl:when test="$mode='members'">			
					<xsl:apply-templates select="." mode="members"/>
				</xsl:when>
				<xsl:when test="$mode='member'">			
					<xsl:apply-templates select="." mode="member"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="."/>
				</xsl:otherwise>
			 </xsl:choose>
		</xsl:result-document>
	</xsl:template>


</xsl:stylesheet>

