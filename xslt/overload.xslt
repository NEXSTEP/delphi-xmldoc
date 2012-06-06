<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmldoc="http://embarcadero.com" >

	<!-- -->
	<xsl:template match="procedure | function" mode="overloads">
		<html dir="LTR">
			<xsl:call-template name="html-head">
				<xsl:with-param name="title" select="@name" />
			</xsl:call-template>
			<body id="bodyID" class="dtBODY">
				<!--xsl:variable name="namespace" select="../../../@name" /-->
				<xsl:variable name="namespace" select="/namespace/@name" />
				<xsl:variable name="metatype" select="local-name()"/>
				<xsl:variable name="name" select="@name"/>
				<xsl:call-template name="title-row">
					<xsl:with-param name="type-name" select="concat(@name, ' ', $typeConfigurations/node()[name()=$metatype]/singular)" />
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
										<xsl:call-template name="get-overload-filename">
											<xsl:with-param name="namespace" select="$namespace" />
											<xsl:with-param name="name" select="$name" />
										</xsl:call-template>
										
									</xsl:attribute>
									<xsl:apply-templates select="self::node()" mode="syntax" />
								</a>
							</blockquote>
						</p>
					</xsl:for-each>

					<!--xsl:call-template name="overloads-remarks-section" />
					<xsl:call-template name="overloads-example-section" /-->
					<xsl:call-template name="overloads-seealso-section" />
				</div>
				<div>
				<hr />
				</div>
			</body>

		</html>
	</xsl:template>
</xsl:stylesheet>
