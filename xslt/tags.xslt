<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Pass through most common html tags -->
<xsl:template match="p|ol|ul|li|dl|dt|dd|table|tr|th|td|a|img|b|i|strong|em|del|sub|sup|br|hr|h1|h2|h3|h4|h5|h6|pre|div|span|blockquote|abbr|acronym|u|font|map|area">
	<xsl:copy>
		<xsl:copy-of select="@*" />
		<xsl:apply-templates />
	</xsl:copy>
</xsl:template>


<!-- Section Tags -->
<!--
    <summary>
    <typeparam>
    <param>
    <returns>
    <value>
    <exception>
    <permission>
    <remarks>
    <comments>
    // <example>
    // <seealso>
    // <include>
    // <preliminary>
    // <threadsafety>
-->

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

<!--xsl:template match="summary|remarks|value|returns|comments|example">
    <xsl:call-template name="section">
	<xsl:with-param name="type">
		<xsl:value-of select="local-name()" />
	</xsl:with-param>
    </xsl:call-template>
</xsl:template-->

<xsl:template name="seealso-section">
	<xsl:if test="./devnotes/seealso or local-name()!='namespace'">
	        <h3>
        	    <xsl:value-of select="$sectionConfigurations/node()[name()='seealso']" /> 
	        </h3>
		<p>
			<xsl:choose>
				<xsl:when test="local-name()='class' or local-name()='struct' or local-name()='interface'">
					<xsl:call-template name="get-link-for-type-members">
						<xsl:with-param name="namespace" select="../@name" />
						<xsl:with-param name="name" select="@name" />
						<xsl:with-param name="suffix">Members</xsl:with-param>
					</xsl:call-template>
					<xsl:text> | </xsl:text>
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="local-name()!='namespace'">
				<xsl:call-template name="get-link-for-namespace">
					<xsl:with-param name="namespace" select="../@name" />
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

<xsl:template name="see-cref" match="see[@cref]">
	<a>
		<xsl:attribute name="href">
			<xsl:call-template name="get-cref-to-href">
				<xsl:with-param name="cref" select="@cref" />
			</xsl:call-template>
		</xsl:attribute>
		<xsl:attribute name="title">
			<xsl:value-of select="translate(substring-after(@cref, ':'), '{}', '.&lt;&gt;')" />
		</xsl:attribute>
		<xsl:choose>
			<xsl:when test="normalize-space(.)">
				<xsl:value-of select="." />
			</xsl:when>
      <!--xsl:when test="contains(@cref, '|')">
				<xsl:value-of select="translate(substring-after(@cref, '|'), '{}', '&lt;&gt;')" />
			</xsl:when-->
			<xsl:otherwise>
        <xsl:value-of select="translate(substring-after(@cref, ':'), '{}', '.&lt;&gt;')" />
      </xsl:otherwise>
		</xsl:choose>
    </a>
</xsl:template>

<xsl:template name="see-href" match="see[@href]">
    <a target="_blank" href="{@href}" title="{@href}">
        <xsl:choose>
            <xsl:when test="normalize-space(.)">
                <xsl:value-of select="." />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@href" />
            </xsl:otherwise>
        </xsl:choose></a>
</xsl:template>



<!--xsl:template match="typeparam|param">
	<dt>
		<span>
            <xsl:attribute name="class">
                <xsl:value-of select="local-name()" />
            </xsl:attribute>
            <xsl:value-of select="@name"/>
        </span>
	</dt>
	<dd>
		<xsl:apply-templates />
	</dd>
</xsl:template-->

<!--xsl:template match="exception|permission">
	<dt>
        <a>
            <xsl:attribute name="href">
                <xsl:text>helpinsight:/typelink:</xsl:text>
                <xsl:value-of select="@cref" />
            </xsl:attribute>

            <xsl:choose>
                <xsl:when test="string(@DisplayName)!=string(@cref)">
                    <xsl:value-of select="@DisplayName" />
                </xsl:when>
                <xsl:when test="contains(@cref, '|')">
                    <xsl:value-of select="translate(substring-after(@cref, '|'), '{}', '&lt;&gt;')" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(@cref, '{}', '&lt;&gt;')" />
                </xsl:otherwise>
            </xsl:choose>
        </a>
	</dt>
	<dd>
		<xsl:apply-templates />
	</dd>
</xsl:template-->

<!-- Block Tags -->
<!--
    <para>
    <code>
    <list>
    <note>
-->

<xsl:template match="para">
	<p>
    	<xsl:apply-templates />
	</p>
</xsl:template>

<xsl:template match="code">
    <div class="code">
        <table>
            <thead>
            <tr>
                <th>
                    <xsl:value-of select="@lang" />
                </th>
            </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
		        <pre class="code"><xsl:apply-templates /></pre>
                    </td>
                </tr>
            </tbody>
        </table>
        <!--pre class="code">
            <xsl:apply-templates />
            <xsl:apply-templates select="*|text()"/>
        </pre-->
    </div>
</xsl:template>



<xsl:template match="list[@type='bullet']">
    <ul>
        <xsl:for-each select="item">
            <li>
                <xsl:apply-templates />
            </li>
        </xsl:for-each>
    </ul>
</xsl:template>

<xsl:template match="list[@type='number']">
    <ol>
        <xsl:for-each select="item">
            <li>
                <xsl:apply-templates />
            </li>
        </xsl:for-each>
    </ol>
</xsl:template>

<xsl:template match="list[@type='table']">
    <table cellspacing="0">
        <xsl:if test="listheader">
            <thead>
                <tr>
                    <th><xsl:value-of select="listheader/term" /></th>
                    <th><xsl:value-of select="listheader/description" /></th>
                </tr>
            </thead>
        </xsl:if>
        <tbody>
            <xsl:for-each select="item">
                <tr>
                    <td><p><xsl:apply-templates select="term/node()" /></p></td>
                    <td><p><xsl:apply-templates select="description/node()" /></p></td>
                </tr>
            </xsl:for-each>
        </tbody>
    </table>
</xsl:template>

<xsl:template match="note">
    <xsl:variable name="value" select="@type" />
    <xsl:variable name="option" select="$noteConfigurations/node()[name()=$value]" />
    <xsl:call-template name="insertNote">
        <xsl:with-param name="type" select="@type" />
        <xsl:with-param name="title" select="$option/title" />
        <xsl:with-param name="iconUri">
            <xsl:text>images\</xsl:text>
            <xsl:value-of select="$option/iconUri" />
        </xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template name="insertNote">
    <xsl:param name="type" />
    <xsl:param name="iconUri" />
    <xsl:param name="title" select="'Note:'" />
    <div class="note">
        <table>
            <thead>
            <tr>
                <th>
                    <img src="{$iconUri}" class="note" title="Note" />
                    <span class="note"><xsl:value-of select="$title" /></span>
                </th>
            </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <div>
                            <xsl:choose>
                                <xsl:when test="para|p">
                                    <xsl:apply-templates />
                                </xsl:when>
                                <xsl:otherwise>
                                    <p>
                                        <xsl:apply-templates />
                                    </p>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</xsl:template>


<!-- Inline Tags -->

<!--
    <c>
    <paramref>
    <typeparamref>
    <see>
-->

<xsl:template match="c">
	<tt class="inlineCode">
        <xsl:apply-templates/>
    </tt>
</xsl:template>

<xsl:template match="paramref">
	<span class="paramref">
    	<xsl:value-of select="@name"/>
    </span>
</xsl:template>

<xsl:template match="typeparamref">
	<span class="typeparamref">
        <xsl:value-of select="@name"/>
    </span>
</xsl:template>

</xsl:stylesheet>
