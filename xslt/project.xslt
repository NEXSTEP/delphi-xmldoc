<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" indent="yes"  encoding="utf-8" omit-xml-declaration="yes"/>

	<!-- -->
	<xsl:include href="namespace.xslt" />

	<xsl:template match="/">
		<xsl:apply-templates mode="project"/>
	</xsl:template>

	<xsl:template match="namespace" mode="project">
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
				<xsl:variable name='ns-xml' select="document(concat(document-uri(/), '/../', @name, '.xml'))" />
			        <xsl:apply-templates select="$ns-xml/namespace/devnotes/summary" />

  			        <xsl:apply-templates select="$ns-xml" mode="namespace"/>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>