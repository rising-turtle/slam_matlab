






  


  
  
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
  <head>
      <meta http-equiv="X-UA-Compatible" content="IE=8" />
      	<script type="text/javascript" src="/includes_content/nextgen/scripts/jquery/jquery-latest.js"></script>
      <!-- START OF GLOBAL NAV -->
  <link rel="stylesheet" href="/matlabcentral/css/sitewide.css" type="text/css" />
  <link rel="stylesheet" href="/matlabcentral/css/mlc.css" type="text/css" />
  <!--[if lt IE 7]>
  <link href="/matlabcentral/css/ie6down.css" type="text/css" rel="stylesheet">
  <![endif]-->

      
      <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<meta name="keywords" content="file exchange, matlab answers, newsgroup access, link exchange, matlab blog, matlab central, simulink blog, matlab community, matlab and simulink community" />
<meta name="description" content="File exchange, MATLAB Answers, newsgroup access, Links, and Blogs for the MATLAB &amp; Simulink user community" />
<link rel="stylesheet" href="/matlabcentral/css/fileexchange.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="print" href="/matlabcentral/css/print.css" />
<title>Kabsch algorithm: Kabsch(P, Q, m) - File Exchange - MATLAB Central</title>
<script src="/matlabcentral/fileexchange/javascripts/prototype.js?1333472917" type="text/javascript"></script>
<script src="/matlabcentral/fileexchange/javascripts/effects.js?1333472917" type="text/javascript"></script>
<script src="/matlabcentral/fileexchange/javascripts/dragdrop.js?1333472917" type="text/javascript"></script>
<script src="/matlabcentral/fileexchange/javascripts/controls.js?1333472917" type="text/javascript"></script>
<script src="/matlabcentral/fileexchange/javascripts/application.js?1333472917" type="text/javascript"></script>
<script src="/matlabcentral/fileexchange/javascripts/searchfield.js?1333472917" type="text/javascript"></script>
<link href="/matlabcentral/fileexchange/stylesheets/application.css?1333472917" media="screen" rel="stylesheet" type="text/css" />
<link rel="search" type="application/opensearchdescription+xml" title="Search File Exchange" href="/matlabcentral/fileexchange/search.xml" />


  </head>
    <body>
      <div id="header">
  <div class="wrapper">
  <!--put nothing in left div - only 11px wide shadow --> 
    <div class="main">
        	<div id="logo"><a href="/matlabcentral/" title="MATLAB Central Home"><img src="/matlabcentral/images/mlclogo-whitebgd.gif" alt="MATLAB Central" /></a></div>
      
        <div id="headertools">
        

<script language="JavaScript1.3" type="text/javascript">

function submitForm(query){

	choice = document.forms['searchForm'].elements['search_submit'].value;
	
	if (choice == "entire1" || choice == "contest" || choice == "matlabcentral" || choice == "blogs"){
	
	   var newElem = document.createElement("input");
	   newElem.type = "hidden";
	   newElem.name = "q";
	   newElem.value = query.value;
	   document.forms['searchForm'].appendChild(newElem);
	      
	   submit_action = '/searchresults/';
	}
	
	switch(choice){
	   case "matlabcentral":
	      var newElem = document.createElement("input");
	      newElem.type = "hidden";
	      newElem.name = "c[]";
	      newElem.value = "matlabcentral";
	      document.forms['searchForm'].appendChild(newElem);
	
	      selected_index = 0;
	      break
	   case "fileexchange":
	      var newElem = document.createElement("input");
	      newElem.type = "hidden";
	      newElem.name = "term";
	      newElem.value = query.value;
	      newElem.classname = "formelem";
	      document.forms['searchForm'].appendChild(newElem);
	
	      submit_action = "/matlabcentral/fileexchange/";
	      selected_index = 1;
	      break
	   case "answers":
	      var newElem = document.createElement("input");
	      newElem.type = "hidden";
	      newElem.name = "term";
	      newElem.value = query.value;
	      newElem.classname = "formelem";
	      document.forms['searchForm'].appendChild(newElem);
	
	      submit_action = "/matlabcentral/answers/";
	      selected_index = 2;
	      break
	   case "cssm":
	      var newElem = document.createElement("input");
	      newElem.type = "hidden";
	      newElem.name = "search_string";
	      newElem.value = query.value;
	      newElem.classname = "formelem";
	      document.forms['searchForm'].appendChild(newElem);
	
		  submit_action = "/matlabcentral/newsreader/search_results";
	      selected_index = 3;
	      break
	   case "linkexchange":
	      var newElem = document.createElement("input");
	      newElem.type = "hidden";
	      newElem.name = "term";
	      newElem.value = query.value;
	      newElem.classname = "formelem";
	      document.forms['searchForm'].appendChild(newElem);
	
	      submit_action = "/matlabcentral/linkexchange/";
	      selected_index = 4;
	      break
	   case "blogs":
	      var newElem = document.createElement("input");
	      newElem.type = "hidden";
	      newElem.name = "c[]";
	      newElem.value = "blogs";
	      document.forms['searchForm'].appendChild(newElem);
	
	      selected_index = 5;
	      break
	   case "trendy":
	      var newElem = document.createElement("input");
	      newElem.type = "hidden";
	      newElem.name = "search";
	      newElem.value = query.value;
	      newElem.classname = "formelem";
	      document.forms['searchForm'].appendChild(newElem);
	
	      submit_action = "/matlabcentral/trendy";
	      selected_index = 6;
	      break
	   case "cody":
	      var newElem = document.createElement("input");
	      newElem.type = "hidden";
	      newElem.name = "term";
	      newElem.value = query.value;
	      newElem.classname = "formelem";
	      document.forms['searchForm'].appendChild(newElem);
	
	      submit_action = "/matlabcentral/cody/";
	      selected_index = 7;
	      break
	   case "contest":
	      var newElem = document.createElement("input");
	      newElem.type = "hidden";
	      newElem.name = "c[]";
	      newElem.value = "contest";
	      document.forms['searchForm'].appendChild(newElem);
	
	      selected_index = 8;
	      break
	   case "entire1":
	      var newElem = document.createElement("input");
	      newElem.type = "hidden";
	      newElem.name = "c[]";
	      newElem.value = "entiresite";
	      document.forms['searchForm'].appendChild(newElem);
	      
	      selected_index = 9;
	      break
	   default:
	      var newElem = document.createElement("input");
	      newElem.type = "hidden";
	      newElem.name = "c[]";
	      newElem.value = "entiresite";
	      document.forms['searchForm'].appendChild(newElem);
	   
	      selected_index = 9;
	      break
	}

	document.forms['searchForm'].elements['search_submit'].selectedIndex = selected_index;
	document.forms['searchForm'].elements['query'].value = query.value;
	document.forms['searchForm'].action = submit_action;
}

</script>


  <form name="searchForm" method="GET" action="" style="margin:0px; margin-top:5px; font-size:90%" onsubmit="submitForm(query)">
          <label for="search">Search: </label>
        <select name="search_submit" style="font-size:9px ">
         	 <option value="matlabcentral">MATLAB Central</option>
          	<option value="fileexchange" selected>&nbsp;&nbsp;&nbsp;File Exchange</option>
          	<option value="answers">&nbsp;&nbsp;&nbsp;Answers</option>
            <option value="cssm">&nbsp;&nbsp;&nbsp;Newsgroup</option>
          	<option value="linkexchange">&nbsp;&nbsp;&nbsp;Link Exchange</option>
          	<option value="blogs">&nbsp;&nbsp;&nbsp;Blogs</option>
          	<option value="trendy">&nbsp;&nbsp;&nbsp;Trendy</option>
          	<option value="cody">&nbsp;&nbsp;&nbsp;Cody</option>
          	<option value="contest">&nbsp;&nbsp;&nbsp;Contest</option>
          <option value="entire1">MathWorks.com</option>
        </select>
<input type="text" name="query" size="10" class="formelem" value="" />
<input type="submit" value="Go" class="formelem gobutton" />
</form>


        <ol id="access2">
            
            
	          
              
                <li class="first">
                  
		    Amirhossein Tamjidi
                  
		</li>
                <li><a href="/accesslogin/editCommunityProfile.do?uri=/matlabcentral/fileexchange/25746-kabsch-algorithm/content/Kabsch.m">Create Community Profile</a></li>
                <li><a href="https://www.mathworks.com/accesslogin/logout.do?uri=http://www.mathworks.com/matlabcentral/fileexchange/25746-kabsch-algorithm/content/Kabsch.m">Log Out</a></li>
              
            
        </ol>
      </div>
	  
        <div id="globalnav">
        <!-- from includes/global_nav.html -->
        <ol>
                <li class="active">
                        <a href="/matlabcentral/fileexchange/">File Exchange</a> 
                </li>
                <li class=";">
                        <a href="/matlabcentral/answers/">Answers</a> 
                </li>
                <li class=";">
                        <a href="/matlabcentral/newsreader/">Newsgroup</a> 
                </li>
                <li class=";">
                        <a href="/matlabcentral/linkexchange/">Link Exchange</a> 
                </li>
                <li class=";">
                        <a href="http://blogs.mathworks.com/">Blogs</a> 
                </li>
                <li class=";">
                        <a href="/matlabcentral/trendy">Trendy</a> 
                </li>
                <li class=";">
                        <a href="/matlabcentral/cody">Cody</a> 
                </li>
                <li class=";">
                        <a href="/matlabcentral/contest/">Contest</a> 
                </li>
                <li class="icon mathworks">
                        <a href="/">MathWorks.com</a> 
                </li>
        </ol>
      </div>
    </div>
  </div>
</div>

      <div id="middle">
  <div class="wrapper">

    <div id="mainbody" class="columns2">


  <div class="manifest">
  <div class="ctaBtn ctaBlueBtn btnSmall">
    <div class="btnCont">
      <div class="btn download">
        <a href="http://www.mathworks.com/matlabcentral/fileexchange/25746-kabsch-algorithm?controller=file_infos&amp;download=true" title="Download Now">Download All</a>
      </div>  
    </div>
  </div>

  
  <p class="license">   
    
      Code covered by the <a href="/matlabcentral/fileexchange/view_license?file_info_id=25746" onclick="window.open(this.href,'new_window','height=500,width=640,scrollbars=yes');return false;">BSD License</a>
      <a href="/matlabcentral/fileexchange/help_license#bsd" class="info notext" onclick="window.open(this.href,'small','toolbar=no,resizable=yes,status=yes,menu=no,scrollbars=yes,width=600,height=550');return false;">&nbsp;</a>
          
  </p>
  <h3 class="highlights_title">
    Highlights from<br/>
    <a href="http://www.mathworks.com/matlabcentral/fileexchange/25746-kabsch-algorithm" class="manifest_title">Kabsch algorithm</a>
  </h3>

  

  <ul class="manifest">
    
      
        <li class="manifest">
          
            <a href="http://www.mathworks.com/matlabcentral/fileexchange/25746-kabsch-algorithm/content/Kabsch.m" class="function" title="Function">Kabsch(P, Q, m)</a>
          
          <span class="description">Find the Least Root Mean Square between two sets of N points in D dimensions</span>
        </li>
      
    
    <li class="manifest_allfiles">
      <a href="http://www.mathworks.com/matlabcentral/fileexchange/25746-kabsch-algorithm/all_files">View all files</a></li>
  </ul>
</div>

  <table cellpadding="0" cellspacing="0" class="details file">
    <tr>
      <th class="maininfo"> 

        
        <div id="details" class="content_type_details">
          from 
          <a href="/matlabcentral/fileexchange/file_infos/25746-kabsch-algorithm" class="content_type_author">Kabsch algorithm</a></h2>
          by <a href="/matlabcentral/fileexchange/authors/75295">Ehud Schreiber</a>
          <br/>Find the rigid transformation & Least Root Mean Square distance between two paired sets of points
          </p>
        </div>
      </th>
    </tr>
    <tr>
      <td class="file">
        <table cellpadding="0" cellspacing="0" border="0" class="fileview section">
          <tr class="title">
            <th><span class="heading">Kabsch(P, Q, m)</span></th>
          </tr>
          <tr>
            <td>
              
                
                <div class="codecontainer"><pre class="matlab-code">% Find the Least Root Mean Square between two sets of N points in D dimensions
% and the rigid transformation (i.e. translation and rotation) 
% to employ in order to bring one set that close to the other,
% Using the Kabsch (1976) algorithm.
% Note that the points are paired, i.e. we know which point in one set 
% should be compared to a given point in the other set.
% 
% References:
% 1) Kabsch W. A solution for the best rotation to relate two sets of vectors. Acta Cryst A 1976;32:9223.
% 2) Kabsch W. A discussion of the solution for the best rotation to relate two sets of vectors. Acta Cryst A 1978;34:8278.
% 3) http://cnx.org/content/m11608/latest/
% 4) http://en.wikipedia.org/wiki/Kabsch_algorithm
%
% We slightly generalize, allowing weights given to the points.
% Those weights are determined a priori and do not depend on the distances.
%
% We work in the convention that points are column vectors; 
% some use the convention where they are row vectors instead. 
%
% Input  variables:
%  P : a D*N matrix where P(a,i) is the a-th coordinate of the i-th point 
%      in the 1st representation
%  Q : a D*N matrix where Q(a,i) is the a-th coordinate of the i-th point 
%      in the 2nd representation
%  m : (Optional) a row vector of length N giving the weights, i.e. m(i) is 
%      the weight to be assigned to the deviation of the i-th point.
%      If not supplied, we take by default the unweighted (or equal weighted)
%      m(i) = 1/N.
%      The weights do not have to be normalized; 
%      we divide by the sum to ensure sum_{i=1}^N m(i) = 1.
%      The weights must be non-negative with at least one positive entry.
% Output variables:
%  U : a proper orthogonal D*D matrix, representing the rotation
%  r : a D-dimensional column vector, representing the translation
%  lrms: the Least Root Mean Square
%
% Details:
% If p_i, q_i are the i-th point (as a D-dimensional column vector) 
% in the two representations, i.e. p_i = P(:,i) etc., and for 
% p_i' = U p_i + r      (' does not stand for transpose!)
% we have p_i' ~ q_i, that is, 
% lrms = sqrt(sum_{i=1}^N m(i) (p_i' - q_i)^2)
% is the minimal rms when going over the possible U and r.
% (assuming the weights are already normalized).
%
function[U, r, lrms] = Kabsch(P, Q, m)
	sz1 = size(P) ;
	sz2 = size(Q) ;
	if (length(sz1) ~= 2 || length(sz2) ~= 2)
		error 'P and Q must be matrices' ;
	end
	if (any(sz1 ~= sz2))
		error 'P and Q must be of same size' ;
	end
	D = sz1(1) ;         % dimension of space
	N = sz1(2) ;         % number of points
	if (nargin &gt;= 3)
		if (~isvector(m) || any(size(m) ~= [1 N]))
			error 'm must be a row vector of length N' ;
		end 
		if (any(m &lt; 0))
			error 'm must have non-negative entries' ;
		end
		msum = sum(m) ;
		if (msum == 0)
			error 'm must contain some positive entry' ;
		end
		m = m / msum ;     % normalize so that weights sum to 1
	else                 % m not supplied - use default
		m = ones(1,N)/N ;
	end

	p0 = P*m' ;          % the centroid of P
	q0 = Q*m' ;          % the centroid of Q
	v1 = ones(1,N) ;     % row vector of N ones
	P = P - p0*v1 ;      % translating P to center the origin
	Q = Q - q0*v1 ;      % translating Q to center the origin

	% C is a covariance matrix of the coordinates
	% C = P*diag(m)*Q' 
	% but this is inefficient, involving an N*N matrix, while typically D &lt;&lt; N.
	% so we use another way to compute Pdm = P*diag(m)
	Pdm = zeros(D,N) ;
	for i=1:N
		Pdm(:,i) = m(i)*P(:,i) ;
	end
	C = Pdm*Q' ; 	
%	C = P*Q' / N ;       % (for the non-weighted case)       
	[V,S,W] = svd(C) ;   % singular value decomposition
	I = eye(D) ;
	if (det(C) &lt; 0)
		I(D,D) = -1 ;
	end
	U = W*I*V' ;

	r = q0 - U*p0 ;

	Diff = U*P - Q ;     % P, Q already centered
%	lrms = sqrt(sum(sum(Diff.*Diff))/N) ; % (for the non-weighted case)
	lrms = 0 ;
	for i=1:N
		lrms = lrms + m(i)*Diff(:,i)'*Diff(:,i) ;
	end
	lrms = sqrt(lrms) ;
end
</pre></div>
              
            </td>
          </tr>
        </table>
  


      </td>
    </tr>
  
  </table>


<p id="contactus">Contact us at <a href="mailto:files@mathworks.com">files@mathworks.com</a></p>

      
</div>
<div class="clearboth">&nbsp;</div>
</div>
</div>
<!-- footer.html -->
<!-- START OF FOOTER -->

<div id="mlc-footer">
  <script type="text/javascript">
function clickDynamic(obj, target_url, tracking_code) {
	var pos=target_url.indexOf("?");
	if (pos<=0) { 
		var linkComponents = target_url + tracking_code;
		obj.href=linkComponents;
	} 
}
</script>
  <div class="wrapper">
    <div>
      <ul id="matlabcentral">
        <li class="copyright first">&copy; 1994-2012 The MathWorks, Inc.</li>
        <li class="first"><a href="/help.html" title="Site Help">Site Help</a></li>
        <li><a href="/company/aboutus/policies_statements/patents.html" title="patents" rel="nofollow">Patents</a></li>
        <li><a href="/company/aboutus/policies_statements/trademarks.html" title="trademarks" rel="nofollow">Trademarks</a></li>
        <li><a href="/company/aboutus/policies_statements/" title="privacy policy" rel="nofollow">Privacy Policy</a></li>
        <li><a href="/company/aboutus/policies_statements/piracy.html" title="preventing piracy" rel="nofollow">Preventing Piracy</a></li>
        <li class="last"><a href="/matlabcentral/termsofuse.html" title="Terms of Use" rel="nofollow">Terms of Use</a></li>
        <li class="icon"><a href="/company/rss/" title="RSS" class="rssfeed" rel="nofollow"><span class="text">RSS</span></a></li>
        <li class="icon"><a href="http://www.mathworks.com/programs/bounce_hub_generic.html?s_cid=mlc_fbk&url=http://www.facebook.com/MATLAB" title="Facebook" class="facebook" rel="nofollow"><span class="text">Facebook</span></a></li>
        <li class="last icon"><a href="http://www.mathworks.com/programs/bounce_hub_generic.html?s_cid=mlc_twt&url=http://www.twitter.com/MATLAB" title="Twitter" class="twitter" rel="nofollow"><span class="text">Twitter</span></a></li>
      </ul>
      <ul id="mathworks">
        <li class="first sectionhead">Featured MathWorks.com Topics:</li>
        <li class="first"><a href="/products/new_products/latest_features.html" onclick="clickDynamic(this, this.href, '?s_cid=MLC_new')">New Products</a></li>
        <li><a href="/support/" title="support" onclick="clickDynamic(this, this.href, '?s_cid=MLC_support')">Support</a></li>
        <li><a href="/help" title="documentation" onclick="clickDynamic(this, this.href, '?s_cid=MLC_doc')">Documentation</a></li>
        <li><a href="/services/training/" title="training" onclick="clickDynamic(this, this.href, '?s_cid=MLC_training')">Training</a></li>
        <li><a href="/company/events/webinars/" title="Webinars" onclick="clickDynamic(this, this.href, '?s_cid=MLC_webinars')">Webinars</a></li>
        <li><a href="/company/newsletters/" title="newsletters" onclick="clickDynamic(this, this.href, '?s_cid=MLC_newsletters')">Newsletters</a></li>
        <li><a href="/programs/trials/trial_request.html?prodcode=ML&s_cid=MLC_trials" title="MATLAB Trials">MATLAB Trials</a></li>
        
                <li class="last"><a href="/company/jobs/opportunities/index_en_US.html" title="Careers" onclick="clickDynamic(this, this.href, '?s_cid=MLC_careers')">Careers</a></li>
                 
      </ul>
    </div>
  </div>
</div>
<!-- END OF FOOTER -->


      
      
<!-- SiteCatalyst code version: H.4. -->
<script language="JavaScript" type="text/javascript" src="/includes_content/jscript/omniture/s_code.js"></script>
<script language="JavaScript" type="text/javascript"><!--
s.pageName=document.title

s.eVar13='Version B'; //code for testing two versions of the intro text on the homepage products tab


/************* DO NOT ALTER ANYTHING BELOW THIS LINE ! **************/
var s_code=s.t();if(s_code)document.write(s_code)//--></script>
<script language="JavaScript" type="text/javascript"><!--
if(navigator.appVersion.indexOf('MSIE')>=0)document.write(unescape('%3C')+'\!-'+'-')
//--></script><!--/DO NOT REMOVE/-->
<!-- End SiteCatalyst code version: H.4. -->

<!--JF: Jai and I added the following code for GA to test mobile devices.  12/23/10 -->


<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-7506924-7']);
  _gaq.push(['_setDomainName', 'none']);
  _gaq.push(['_setAllowLinker', true]);
     var whichSection = location.href.split("/");
	
	 
	if ((whichSection[3]) && (whichSection[3].lastIndexOf(".html") == -1)) { 
  	 _gaq.push(['_setCustomVar', 1, 'Section1', whichSection[3], 3]);
	// alert(whichSection[3]);
	}
	if ((whichSection[4]) && (whichSection[4].lastIndexOf(".html") == -1)) { 
  whichSectionCombined = whichSection[3] + "/" + whichSection[4];
	 _gaq.push(['_setCustomVar', 2, 'Section2', whichSectionCombined, 3]);
	// alert(whichSectionCombined);
	}
	if ((whichSection[5]) && (whichSection[5].lastIndexOf(".html") == -1)) { 
  whichSectionCombined = whichSection[3] + "/" + whichSection[4] + "/" + whichSection[5];
	 _gaq.push(['_setCustomVar', 3, 'Section3', whichSectionCombined, 3]);
	  //alert(whichSectionCombined);
	}
	
_gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>

    </body>
</html>
