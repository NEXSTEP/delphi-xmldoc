<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmldoc="http://embarcadero.com" >

	<!-- -->
	<xsl:template match="constructor | destructor | procedure | function | const | field | event | property" mode="member-overloads">
		<html dir="LTR">
			<xsl:call-template name="html-head">
				<xsl:with-param name="title" select="@name" />
			</xsl:call-template>
			<body id="bodyID" class="dtBODY">
				<xsl:variable name="namespace">
					<xsl:choose>
						<xsl:when test="../local-name()='members'">
							<xsl:value-of select="../../../@name" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="../../@name" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="type">
					<xsl:choose>
						<xsl:when test="../local-name()='members'">
							<xsl:value-of select="../../@name" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="../@name" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="parent-metatype">
					<xsl:choose>
						<xsl:when test="../local-name()='members'">
							<xsl:value-of select="../../local-name()" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="../local-name()" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="metatype" select="local-name()"/>
				<xsl:variable name="name" select="@name"/>
				<xsl:call-template name="title-row">
					<xsl:with-param name="type-name" select="concat($type, '.', @name, ' ', $typeConfigurations/node()[name()=$metatype]/singular)" />
				</xsl:call-template>
				<div id="nstext">
					<!--xsl:call-template name="overloads-summary-section" /-->
					<h4 class="dtH4">Overload List</h4>
					<xsl:for-each select="parent::node()/*[@name=$name]">
						<p>
							<xsl:call-template name="summary-with-no-paragraph" />
							<blockquote class="dtBlock">
								<a>
									<xsl:attribute name="href">
										<xsl:call-template name="get-member-filename" />
									</xsl:attribute>
									<xsl:apply-templates select="self::node()" mode="syntax" />
								</a>
							</blockquote>
						</p>
					</xsl:for-each>

					<!--xsl:call-template name="overloads-remarks-section" />
					<xsl:call-template name="overloads-example-section" /-->
					<xsl:call-template name="overloads-seealso-section">
						<xsl:with-param name="page">members</xsl:with-param>
					</xsl:call-template>
				</div>
				<div>
				<hr />
				</div>
			</body>

		</html>
	</xsl:template>
</xsl:stylesheet>
