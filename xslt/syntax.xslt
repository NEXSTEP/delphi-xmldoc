<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="syntax-section">
		<pre class="syntax">
			<b>
				<xsl:apply-templates select="." mode="syntax" />
			</b>
		</pre>
	</xsl:template>

	<xsl:template match="@* | node() | text()" mode="syntax" />

	<xsl:template match="class | interface | struct" mode="syntax">
		<xsl:value-of select="@name" />
		<xsl:text> = </xsl:text>
		<xsl:value-of select="local-name()" />
		<xsl:text>(</xsl:text>
		<xsl:choose>
			<xsl:when test="local-name()='class'">
				<xsl:value-of select="./ancestor/@name" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@ancestor" />
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>)</xsl:text>
		<xsl:text>; </xsl:text>
	</xsl:template>

	<xsl:template match="struct" mode="syntax">
		<xsl:value-of select="@name" />
		<xsl:text> = record;</xsl:text>
	</xsl:template>

	<xsl:template match="field | property | event | variable | const" mode="syntax">
		<xsl:call-template name="syntax-visibility"/>
		<xsl:choose>
			<xsl:when test="local-name()='type' or local-name()='pointer'">
				<xsl:text>type</xsl:text>
			</xsl:when>
			<xsl:when test="local-name()='field'">
				<xsl:text>var</xsl:text>
			</xsl:when>
			<xsl:when test="local-name()='variable'">
				<xsl:text>var</xsl:text>
			</xsl:when>
			<xsl:when test="local-name()='const'">
				<xsl:text>const</xsl:text>
			</xsl:when>
			<xsl:when test="local-name()='property'">
				<xsl:text>property</xsl:text>
			</xsl:when>
			<xsl:when test="local-name()='event'">
				<xsl:text>property</xsl:text>
			</xsl:when>
		</xsl:choose>
		<xsl:text> </xsl:text>
		
		<xsl:value-of select="@name" />
		<xsl:text>: </xsl:text>
		<xsl:if test="@type">
			<xsl:value-of select="@type" />
		</xsl:if>
		<xsl:if test="array">
			<xsl:apply-templates select="array" mode="syntax-array" />
		</xsl:if>
		<xsl:if test="./value">
			<xsl:text> = </xsl:text>
			<xsl:value-of select="normalize-space(value)" />
		</xsl:if>
		<xsl:text>; </xsl:text>
	</xsl:template>

	<xsl:template match="array" mode="syntax-array">
		<xsl:text>array</xsl:text>
		<xsl:if test="@low">
			<xsl:text>[</xsl:text>
			<xsl:value-of select="@low"/>
			<xsl:text>..</xsl:text>
			<xsl:value-of select="@high"/>
			<xsl:text>]</xsl:text>
		</xsl:if>
		<xsl:if test="element/@type">
			<xsl:text> of </xsl:text>
			<xsl:value-of select="element/@type"/>
		</xsl:if>
		<xsl:if test="array">
			<xsl:text> of </xsl:text>
			<xsl:apply-templates select="array" mode="syntax-array" />
		</xsl:if>
	</xsl:template>
        
	<xsl:template match="type | pointer | array | enum | set | classref" mode="syntax">
		<xsl:call-template name="syntax-visibility"/>
		<xsl:text>type</xsl:text>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@name" />
		<xsl:text> = </xsl:text>
		<xsl:if test="local-name()='set'">
			<xsl:text>set of </xsl:text>
		</xsl:if>
		<xsl:if test="@type">
			<xsl:value-of select="@type" />
		</xsl:if>
		<xsl:if test="local-name()='array'">
			<xsl:apply-templates select="." mode="syntax-array" />
		</xsl:if>
		<xsl:if test="local-name()='enum'">
			<xsl:text>(</xsl:text>
			<xsl:for-each select="element">
				<xsl:value-of select="@name"/>
				<xsl:text> = </xsl:text>
				<xsl:value-of select="@value"/>
				<xsl:if test="position()!= last()">
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:for-each>
			<xsl:text>)</xsl:text>
		</xsl:if>
		<xsl:if test="local-name()='classref'">
			<xsl:text>class of </xsl:text>
			<xsl:value-of select="@ref"/>
		</xsl:if>
		<xsl:text>; </xsl:text>
	</xsl:template>

	<xsl:template match="constructor | destructor | procedure | function" mode="syntax">
		<xsl:call-template name="syntax-visibility"/>
		<xsl:call-template name="syntax-procflag">
			<xsl:with-param name="flag">class</xsl:with-param>
			<xsl:with-param name="delim"> </xsl:with-param>
		</xsl:call-template>
		<xsl:value-of select="local-name()" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="@name" />
		
		<xsl:if test="parameters/parameter">
			<xsl:text>(</xsl:text>
			<xsl:for-each select="parameters/parameter">
				<xsl:text>&#10;</xsl:text>
				<xsl:text>   </xsl:text>
				<xsl:if test="contains(@paramflags, 'var')">
					<xsl:text>var </xsl:text>
				</xsl:if>
				<xsl:if test="contains(@paramflags, 'out')">
					<xsl:text>out </xsl:text>
				</xsl:if>
				<xsl:if test="contains(@paramflags, 'const')">
					<xsl:text>const </xsl:text>
				</xsl:if>
				<xsl:value-of select="@name"/>
				<xsl:if test="@type">
					<xsl:text>: </xsl:text>
					<xsl:value-of select="@type"/>
				</xsl:if>
				<xsl:if test="array">
					<xsl:text>: </xsl:text>
					<xsl:apply-templates select="array" mode="syntax-array" />
				</xsl:if>
				<xsl:if test="value">
					<xsl:text> = </xsl:text>
					<xsl:value-of select="normalize-space(value)"/>
				</xsl:if>
				<xsl:if test="position()!= last()">
					<xsl:text>; </xsl:text>
				</xsl:if>
			</xsl:for-each>
			<xsl:text>&#10;)</xsl:text>
		</xsl:if>

		<xsl:if test="local-name() = 'function'">
			<xsl:text>: </xsl:text>
			<xsl:value-of select="parameters/retval/@type" />
		</xsl:if>

		<xsl:text>; </xsl:text>
		<xsl:call-template name="syntax-procflag">
			<xsl:with-param name="flag">overload</xsl:with-param>
			<xsl:with-param name="delim">; </xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="syntax-procflag">
			<xsl:with-param name="flag">virtual</xsl:with-param>
			<xsl:with-param name="delim">; </xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="syntax-procflag">
			<xsl:with-param name="flag">override</xsl:with-param>
			<xsl:with-param name="delim">; </xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="syntax-procflag">
			<xsl:with-param name="flag">static</xsl:with-param>
			<xsl:with-param name="delim">; </xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="syntax-procflag">
			<xsl:with-param name="flag">abstract</xsl:with-param>
			<xsl:with-param name="delim">; </xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="syntax-procflag">
			<xsl:with-param name="flag">inline</xsl:with-param>
			<xsl:with-param name="delim">; </xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="syntax-visibility">
		<xsl:if test="../local-name() = 'members' or ../local-name() = 'struct'">
			<xsl:if test="@visibility != ''">
				<xsl:value-of select="@visibility" />
				<xsl:text> </xsl:text>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="syntax-procflag">
		<xsl:param name="flag" />
		<xsl:param name="delim" />
		<xsl:if test="contains(@procflags, $flag)">
			<xsl:value-of select="$flag" />
			<xsl:value-of select="$delim" />
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>