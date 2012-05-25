<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" indent="yes"  encoding="utf-8" omit-xml-declaration="yes"/>

	<!-- -->
	<xsl:include href="common.xslt" />
	<xsl:include href="filenames.xslt" />
	<xsl:include href="tags.xslt" />

	<!-- -->
	<xsl:template match="/">
		<!--xsl:result-document href="{namespace/@name}.html"-->
			<xsl:apply-templates select="namespace"/>
		<!--/xsl:result-document-->
	</xsl:template>

	<xsl:template match="namespace">
		<html dir="LTR">
			<xsl:call-template name="html-head">
				<xsl:with-param name="title" select="@name" />
			</xsl:call-template>
			<body id="bodyID" class="dtBODY">
				<xsl:call-template name="title-row">
					<xsl:with-param name="type-name">
						<xsl:value-of select="@name" />
						<xsl:text> Project</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<div id="nstext">
					<h3 class="dtH3">Units</h3>
					<div class="tablediv">
						<table class="dtTABLE" cellspacing="0">
							<tr valign="top">
								<th width="50%">Name</th>
								<th width="50%">Description</th>
							</tr>
							<xsl:apply-templates select="contains">
								<xsl:sort select="@name" />
							</xsl:apply-templates>
						</table>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="contains">
		<tr valign="top">
			<td width="50%">
				<xsl:call-template name="get-link-for-namespace">
					<xsl:with-param name="namespace" select="@name" />
				</xsl:call-template>
			</td>
			<td width="50%">
				<!--xsl:variable name='ns-xml' select=""-->
			        <xsl:apply-templates select="document(concat(document-uri(/), '/../', @name, '.xml'))/namespace/devnotes/summary" />
				<!--xsl:apply-templates select="(devnotes/summary)[1]/node()" />
				<xsl:if test="not((devnotes/summary)[1]/node())">&#160;</xsl:if-->
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>