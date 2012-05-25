<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmldoc="http://embarcadero.com" >

	<xsl:include href="syntax.xslt" />

	<!-- -->
	<xsl:template match="class | struct | interface | procedure | function | const | variable | type | pointer | array | enum | set | classref" mode="type">
		<html dir="LTR">
			<xsl:call-template name="html-head">
				<xsl:with-param name="title" select="@name" />
			</xsl:call-template>
			<body id="bodyID" class="dtBODY">
				<xsl:variable name="type" select="local-name()"/>
				<xsl:call-template name="title-row">
					<xsl:with-param name="type-name" select="concat(@name, ' ', $typeConfigurations/node()[name()=$type]/singular)" />
				</xsl:call-template>
				<div id="nstext">
					<xsl:call-template name="summary-section" />
					<xsl:if test="local-name()='class' or local-name()='struct' or local-name()='interface'">
						<p>For a list of all members of this type, see
							<xsl:call-template name="get-link-for-type-members">
								<xsl:with-param name="namespace" select="../@name" />
								<xsl:with-param name="name" select="@name" />
								<xsl:with-param name="suffix">members</xsl:with-param>
							</xsl:call-template>
						</p>
						
						<xsl:if test="local-name()='class' or local-name()='interface'">
							<h3>Hierarchy</h3>
							<p>
								<xsl:call-template name="draw-hierarchy">
									<xsl:with-param name="list" select="ancestor" />
								</xsl:call-template>
								<xsl:call-template name="indent">
									<xsl:with-param name="count" select="xmldoc:hierarchy-level(./ancestor)" />
								</xsl:call-template>
								<b>
									<xsl:value-of  select="concat(../@name, '.', @name)" />
								</b>
							</p>
						</xsl:if>
					</xsl:if>

					<xsl:call-template name="syntax-section" />

					<xsl:call-template name="parameters-section" />
					<xsl:call-template name="returns-section" />
					<xsl:call-template name="implements-section" />
					<xsl:call-template name="remarks-section" />
					<xsl:call-template name="exceptions-section" />
					<xsl:call-template name="example-section" />
					<xsl:call-template name="comments-section" />
					<xsl:call-template name="seealso-section" />
				</div>
				<div>
				<hr />
				</div>
			</body>

		</html>
	</xsl:template>

	<xsl:template name="indent">
		<xsl:param name="count" />
		<xsl:if test="$count &gt; 0">
			<xsl:text>&#160;&#160;&#160;</xsl:text>
			<xsl:call-template name="indent">
				<xsl:with-param name="count" select="$count - 1" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:function name="xmldoc:hierarchy-level">
		<xsl:param name="list" />

		<xsl:choose>
			<xsl:when test="count($list) &gt; 0">
				<xsl:value-of select="xmldoc:hierarchy-level($list/ancestor) + 1" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xsl:template name="draw-hierarchy">
		<xsl:param name="list" />
		<xsl:if test="count($list) &gt; 0">
			<xsl:call-template name="draw-hierarchy">
				<xsl:with-param name="list" select="$list/ancestor" />
			</xsl:call-template>

			<xsl:call-template name="indent">
				<xsl:with-param name="count" select="xmldoc:hierarchy-level($list) - 1" />
			</xsl:call-template>
			<xsl:call-template name="get-link-for-type">
				<xsl:with-param name="namespace" select="$list/@namespace" />
				<xsl:with-param name="name" select="$list/@name" />
				<xsl:with-param name="include-namespace">1</xsl:with-param>
			</xsl:call-template>
				<!--xsl:value-of select="concat($list/@namespace, '.', $list/@name)" /-->
                        <xsl:value-of disable-output-escaping="yes">&lt;br /&gt;</xsl:value-of>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
