<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="section">
	<xsl:param name="type" />
	<xsl:if test="./devnotes/*[local-name()=$type]/node()">
		<h3>
			<xsl:value-of select="$sectionConfigurations/node()[name()=$type]" /> 
		</h3>
		<xsl:choose>
			<xsl:when test="para|p">
				<xsl:apply-templates select="./devnotes/*[local-name()=$type]/node()" />
			</xsl:when>
			<xsl:otherwise>
				<p>
					<xsl:apply-templates select="./devnotes/*[local-name()=$type]/node()" />
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

<xsl:template name="summary-section">
    <xsl:call-template name="section">
	<xsl:with-param name="type">summary</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template name="summary-with-no-paragraph">
	<xsl:apply-templates select="./devnotes/*[local-name()='summary']/node()" />
</xsl:template>

<xsl:template name="remarks-section">
    <xsl:call-template name="section">
	<xsl:with-param name="type">remarks</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template name="comments-section">
    <xsl:call-template name="section">
	<xsl:with-param name="type">comments</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template name="example-section">
    <xsl:call-template name="section">
	<xsl:with-param name="type">example</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template name="parameters-section">
	<xsl:if test="./devnotes/param">
	        <h3>
        	    <xsl:value-of select="$sectionConfigurations/node()[name()='parameters']" />
	        </h3>
		<dl>
			<xsl:for-each select="./devnotes/param">
				<xsl:variable name="name" select="@name" />
				<dt>
					<i>
						<xsl:value-of select="@name" />
					</i>
				</dt>
				<dd>
					<!--xsl:apply-templates select="parent::node()/devnotes/param[@name=$name]/node()" /-->
					<xsl:apply-templates select="." />
				</dd>
			</xsl:for-each>
		</dl>
	</xsl:if>
</xsl:template>

<xsl:template name="implements-section">
	<xsl:if test="./interfaces/implements">
	        <h3>
        	    <xsl:value-of select="$sectionConfigurations/node()[name()='implements']" />
	        </h3>
		<xsl:for-each select="./interfaces/implements">
		<p>
			<!--a><xsl:attribute name="href">
				<xsl:call-template name="get-cref-to-href">
					<xsl:with-param name="cref" select="../@name" />
				</xsl:call-template>
				</xsl:attribute>
			<xsl:value-of select="@name" /></a-->
			<xsl:value-of select="@name" />
		</p>
		</xsl:for-each>
	</xsl:if>
</xsl:template>

<xsl:template name="returns-section">
	<xsl:if test="./devnotes/returns">
	        <h3>
        	    <xsl:value-of select="$sectionConfigurations/node()[name()='returns']" />
	        </h3>
		<p>
			<xsl:apply-templates select="./devnotes/returns" />
		</p>
	</xsl:if>
</xsl:template>

<xsl:template name="exceptions-section">
	<xsl:if test="./devnotes/exception">
	        <h3>
        	    <xsl:value-of select="$sectionConfigurations/node()[name()='exception']" />
	        </h3>
		<div class="tablediv">
			<table class="dtTABLE" cellspacing="0">
				<tr valign="top">
					<th width="50%">Exception Type</th>
					<th width="50%">Condition</th>
				</tr>
				<xsl:for-each select="./devnotes/exception">
					<xsl:sort select="@name" />
					<tr valign="top">
						<td width="50%">
							<a>
								<xsl:attribute name="href">
									<xsl:call-template name="get-cref-to-href">
										<xsl:with-param name="cref" select="@cref" />
									</xsl:call-template>
								</xsl:attribute>
								<xsl:value-of select="substring-after(@cref, ':')" />
							</a>
						</td>
						<td width="50%">
							<xsl:apply-templates select="." />
							<xsl:if test="not(./node())">&#160;</xsl:if>
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</div>
	</xsl:if>
</xsl:template>

<xsl:template name="seealso-section">
	<xsl:if test="./devnotes/seealso or local-name()!='namespace'">
	        <h3>
        	    <xsl:value-of select="$sectionConfigurations/node()[name()='seealso']" /> 
	        </h3>
		<p>

			<xsl:variable name="namespace" select="/namespace/@name" />
			<xsl:variable name="name" select="@name"/>

			<xsl:if test="count(parent::node()/node()[@name=$name]) &gt; 1">
				<a>
					<xsl:attribute name="href">
						<xsl:call-template name="get-filename-for-type">
							<xsl:with-param name="namespace" select="$namespace" />
							<xsl:with-param name="name">
								<xsl:choose>
									<xsl:when test="../local-name()='members'">
										<xsl:value-of select="concat(../../@name, '.', $name)" />
									</xsl:when>
									<xsl:when test="../local-name()='struct' or ../local-name()='interface'">
										<xsl:value-of select="concat(../@name, '.', $name)" />
									</xsl:when>
									<xsl:otherwise>	
										<xsl:value-of select="$name" />
									</xsl:otherwise>	
								</xsl:choose>
							</xsl:with-param>
						
						</xsl:call-template>
					</xsl:attribute>
					<xsl:value-of select="$name" />
					<xsl:text> Overloads</xsl:text>
				</a>
				<xsl:text> | </xsl:text>
			</xsl:if>

			<xsl:if test="../local-name()='members' or ../local-name()='struct' or ../local-name()='interface'">
        			<xsl:variable name="metatype">
					<xsl:choose>
						<xsl:when test="../local-name()='members'">
							<xsl:value-of select="../../local-name()" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="../local-name()" />
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

				<xsl:call-template name="get-link-for-type-members">
					<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="name" select="$type" />
					<xsl:with-param name="suffix">Members</xsl:with-param>
				</xsl:call-template>
				<xsl:text> | </xsl:text>
				<xsl:call-template name="get-link-for-type">
					<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="name" select="$type" />
					<xsl:with-param name="suffix" select="$typeConfigurations/node()[name()=$metatype]/singular" />
				</xsl:call-template>
				<xsl:text> | </xsl:text>
			</xsl:if>

			<xsl:if test="local-name()='class' or local-name()='struct' or local-name()='interface'">
				<xsl:call-template name="get-link-for-type-members">
					<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="name" select="@name" />
					<xsl:with-param name="suffix">Members</xsl:with-param>
				</xsl:call-template>
				<xsl:text> | </xsl:text>
			</xsl:if>
			<xsl:if test="local-name()!='namespace'">
				<xsl:call-template name="get-link-for-namespace">
					<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="suffix">Unit</xsl:with-param>
				</xsl:call-template>
				<xsl:if test="./devnotes/seealso">
					<xsl:text> | </xsl:text>
				</xsl:if>
			</xsl:if>
			<xsl:for-each select="./devnotes/seealso">
				<xsl:choose>
					<xsl:when test="@cref">
						<xsl:call-template name="see-cref" />
					</xsl:when>
					<xsl:when test="@href">
						<xsl:call-template name="see-href" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="." />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="position()!= last()">
					<xsl:text> | </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</p>
	</xsl:if>
</xsl:template>

<xsl:template name="overloads-seealso-section">
	<xsl:param name="page" />
	<h3>
		<xsl:value-of select="$sectionConfigurations/node()[name()='seealso']" /> 
	</h3>
	<p>
		<xsl:if test="$page='members'">
			<xsl:variable name="metatype">
				<xsl:choose>
					<xsl:when test="../local-name()='members'">
						<xsl:value-of select="../../local-name()" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="../local-name()" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="name">
				<xsl:choose>
					<xsl:when test="../local-name()='members'">
						<xsl:value-of select="../../@name" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="../@name" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>


			<xsl:call-template name="get-link-for-type-members">
				<xsl:with-param name="namespace" select="/namespace/@name" />
				<xsl:with-param name="name" select="$name" />
				<xsl:with-param name="suffix">Members</xsl:with-param>
			</xsl:call-template>
			<xsl:text> | </xsl:text>
			<xsl:call-template name="get-link-for-type">
				<xsl:with-param name="namespace" select="/namespace/@name" />
				<xsl:with-param name="name" select="$name" />
				<xsl:with-param name="suffix" select="$typeConfigurations/node()[name()=$metatype]/singular" />
			</xsl:call-template>
			<xsl:text> | </xsl:text>
		</xsl:if>
		<xsl:call-template name="get-link-for-namespace">
			<xsl:with-param name="namespace" select="/namespace/@name" />
			<xsl:with-param name="suffix">Unit</xsl:with-param>
		</xsl:call-template>
	</p>
</xsl:template>


</xsl:stylesheet>
