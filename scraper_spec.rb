require "rspec"
require "fakeweb"
require "ostruct"
require Dir.pwd + "/scraper"

describe "Property Scraper" do
  let(:uri)      { "http://house.ksou.cn/p.php?q=Marrickville&region=Marrickville&sta=nsw" }
  let(:next_uri) { uri + "&p=1" }
  let(:iterator) { Iterator.new("Marrickville", "nsw") }

  before do
    FakeWeb.register_uri(:get, uri, body: html_file, content_type: "text/html")
    FakeWeb.register_uri(:get, next_uri, body: "Unhandled response", status: ["503", "unhandled response"])
  end

  describe "integration test" do
    it "saves the properties of the first page" do
      iterator.scrape_all_pages
      expect(iterator.properties[0].address).to   eq first_result[:address]
      expect(iterator.properties[0].price).to     eq first_result[:price]
      expect(iterator.properties[0].date_sold).to eq first_result[:date_sold]
      expect(iterator.properties[0].type).to      eq first_result[:type]
      expect(iterator.properties[0].bedrooms).to  eq first_result[:bedrooms]
      expect(iterator.properties[0].bathrooms).to eq first_result[:bathrooms]
      expect(iterator.properties[0].carspace).to  eq first_result[:carspace]
    end
  end
end

def first_result
  { address: "52 Ruby Street",
    price: 900000, 
    date_sold: Date.strptime("2014-08-01", "%Y-%m-%d"),
    type: "House", 
    bedrooms: 2, 
    bathrooms: 1, 
    carspace: 1
  }
end

def html_file
  <<-html
    <!doctype html><html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8"><title>
    Marrickville - Property Sold Prices</title>
    <style type="text/css">
    body{font-family:arial,sans-serif;font-size:14px}
    .line{border-top:1px solid #c9d7f1}
    .mark{float:left;width:27px;height:26px;padding-top:3px;margin-bottom:0px;text-align:center;color:#fff;font-size:14px;font-weight:bold;background:transparent url(/img/mark.jpg) no-repeat 0 0}
    .addr{float:left;padding-top:4px;font-weight:bold;-webkit-text-size-adjust:130%}
    A:visited{COLOR: #261cdc}
    .ac_results{padding:0px;border:1px solid black;background-color:white;overflow:hidden;z-index:99999;}
    .ac_results ul{width:100%;list-style-position:outside;list-style: none;padding:0;margin:0;}
    .ac_results li{margin:0px;padding:2px 5px;cursor:default;display:block;font:menu;font-size:12px;line-height:16px;overflow:hidden;}
    .ac_odd{background-color:#eee;}
    .ac_over{background-color:#0A246A;color:white;}
    </style></head><body text=#000000 link=#261cdc bgColor=#ffffff>
    <table width=100% border=0 cellpadding=0><tr><td align=left><b>Home Sold Price</b> | <span id="head_r"><a href="rent.php">Rent Price</a></span> | <span id="head_s"><a href="suburb.php">Suburb Profile</a></span> | <span id="head_new"><a href="newhome.php">New Home</a></span> | <a href="property.php">Property Report</a> | <a href="gallery.php">Gallery</a> | <span id="head_school"><a href="search_school.php">School</a></span><td align=right><a href="about.php">About</a> | <a href="feedback.php">Feedback</a></td></tr></table>
    <table width=100% border=0 cellspacing=0 cellpadding=0 class="line" style="margin-top:3px"><tr><td></td></tr></table>
    <form action="p.php" name=f style="display:inline">
    <table style="margin-top:10px"><tr valign=center><td width=240 align=center>
    <a href="index.php"><img src="/img/logo_s.jpg" border=0 title="Go to Home Page"></a></td>
    <td><input autocomplete="off" maxlength=2048 id="q" name=q value="" size=35 style="background:#fff;border:1px solid #ccc;border-bottom-color:#999;border-right-color:#999;color:#000;font:16px arial,sans-serif bold;height:22px;margin:0;padding:5px 8px 0 6px;vertical-align:top">
    <input type=submit value="Search" style="height:27px;font:15px arial,sans-serif bold"></td>
    <td>
    <script type="text/javascript">
    var browserWidth,browserHeight;
    if(document.documentElement.clientWidth)
    {
      browserWidth = document.documentElement.clientWidth;
      browserHeight = document.documentElement.clientHeight;
    }
    else
    {
      browserWidth = document.body.clientWidth;
      browserHeight = document.body.clientHeight;
    }
    google_ad_client="ca-pub-0330993364398838";
    if(browserWidth>1400)
    {
      google_ad_slot="9049683535";google_ad_width=728;google_ad_height=90;
    }
    else if(browserWidth>=1210)
    {
      google_ad_slot="8126171778";google_ad_width=468;google_ad_height=60;
    }
    else
    {
      google_ad_slot="4711779996";google_ad_width=320;google_ad_height=50;
    }
    function Relocate(addr,sta)
    {
      var s,pos,num, reg=/\d{1}/;
      s=addr;
      pos=s.indexOf(' ');
      if(pos>0)
      {
        num=s.substring(0,pos);
        if(!reg.test(num))
          return(1);
        s=s.substring(pos+1);
      }
      try
      {
        geocoder=new google.maps.Geocoder();
      }
      catch(err)
      {
        window.location.href="notfound.php?q="+addr+"&sta="+sta;
      }
      if(sta=='')
      {
        s=s+', Australia';
      }
      else
      {
        s=s+', '+sta+', Australia';
      }
      geocoder.geocode({"address":s}, function(results, status)
      {
        if(status==google.maps.GeocoderStatus.OK)
        {
          window.location.href='p.php?q='+results[0].formatted_address.replace(/ /g,"+")+'&sta='+sta+'&lat='+results[0].geometry.location.lat()+'&lng='+results[0].geometry.location.lng();
        }
        else
        {
          window.location.href='notfound.php?q='+addr+'&sta='+sta+'&err='+status;
        }
      });
      return(0);
    }
    </script>
    </td></tr></table></form><table width=100% id="mainT"><tr valign=top><td width=190 align=left style="-webkit-text-size-adjust:100%">
    <div style="height:10px"></div>
    <b><font style="font-size:14px">Marrickville <nobr>Median Price</nobr></font></b>
    <table width=100% border=0 cellspacing=0 cellpadding=0 class=line style="margin-top:5px;margin-bottom:5px"><tr><td></td></tr></table>
    <table cellpadding=5 style="font-size:13px" width=100%>
    <tr><td>House</td><td align=right><a href="his_price.php?q=Marrickville&sta=nsw" style="color:black;text-decoration:none" title="9% higher than last year, click to view more">$949,800 <img src="/img/up.gif" border=0></a></td></tr><tr><td>Unit</td><td align=right><a href="his_price.php?q=Marrickville&sta=nsw" style="color:black;text-decoration:none" title="12% higher than last year, click to view more">$563,300 <img src="/img/up.gif" border=0></a></td></tr><tr><td>Land</td><td align=right><a href="his_price.php?q=Marrickville&sta=nsw" style="color:black;text-decoration:none" title="23% lower than last year, click to view more">$775,800 <img src="/img/down.gif" border=0></a></td></tr></table><div style="height:10px"></div><font style="font-size:11px">The House price is <a href="his_price.php?q=Marrickville&sta=nsw" style="color:red" title="View median house price history data">9% higher</a>  than last year.</font><br/><div style="height:20px"></div><b><font style="font-size:14px">Surrounding suburbs</font></b><table width=100% border=0 cellspacing=0 cellpadding=0 class=line style="margin-top:5px;margin-bottom:5px"><tr><td></td></tr></table><table cellpadding=5 style="font-size:13px" width=100%><tr valign=top><td><a href="p.php?q=Dulwich+Hill, NSW">Dulwich Hill</a></td><td align=right><a href="his_price.php?q=Dulwich+Hill&sta=nsw" style="color:black;text-decoration:none" title="18% higher than last year, click to view more">$1,034,800 <img src="/img/up.gif" border=0></a></td></tr><tr valign=top><td><a href="p.php?q=Earlwood, NSW">Earlwood</a></td><td align=right><a href="his_price.php?q=Earlwood&sta=nsw" style="color:black;text-decoration:none" title="19% higher than last year, click to view more">$986,200 <img src="/img/up.gif" border=0></a></td></tr><tr valign=top><td><a href="p.php?q=Enmore, NSW">Enmore</a></td><td align=right><a href="his_price.php?q=Enmore&sta=nsw" style="color:black;text-decoration:none" title="11% higher than last year, click to view more">$974,600 <img src="/img/up.gif" border=0></a></td></tr><tr valign=top><td><a href="p.php?q=Lewisham, NSW">Lewisham</a></td><td align=right><a href="his_price.php?q=Lewisham&sta=nsw" style="color:black;text-decoration:none" title="15% higher than last year, click to view more">$1,059,300 <img src="/img/up.gif" border=0></a></td></tr><tr valign=top><td><a href="p.php?q=Newtown, NSW">Newtown</a></td><td align=right><a href="his_price.php?q=Newtown&sta=nsw" style="color:black;text-decoration:none" title="18% higher than last year, click to view more">$1,045,200 <img src="/img/up.gif" border=0></a></td></tr><tr valign=top><td><a href="p.php?q=Petersham, NSW">Petersham</a></td><td align=right><a href="his_price.php?q=Petersham&sta=nsw" style="color:black;text-decoration:none" title="16% higher than last year, click to view more">$1,033,900 <img src="/img/up.gif" border=0></a></td></tr><tr valign=top><td><a href="p.php?q=St+Peters, NSW">St Peters</a></td><td align=right><a href="his_price.php?q=St+Peters&sta=nsw" style="color:black;text-decoration:none" title="20% higher than last year, click to view more">$932,800 <img src="/img/up.gif" border=0></a></td></tr><tr valign=top><td><a href="p.php?q=Stanmore, NSW">Stanmore</a></td><td align=right><a href="his_price.php?q=Stanmore&sta=nsw" style="color:black;text-decoration:none" title="19% higher than last year, click to view more">$1,182,600 <img src="/img/up.gif" border=0></a></td></tr><tr valign=top><td><a href="p.php?q=Sydenham, NSW">Sydenham</a></td><td align=right><a href="his_price.php?q=Sydenham&sta=nsw" style="color:black;text-decoration:none" title="29% higher than last year, click to view more">$828,900 <img src="/img/up.gif" border=0></a></td></tr><tr valign=top><td><a href="p.php?q=Tempe, NSW">Tempe</a></td><td align=right><a href="his_price.php?q=Tempe&sta=nsw" style="color:black;text-decoration:none" title="23% higher than last year, click to view more">$858,300 <img src="/img/up.gif" border=0></a></td></tr><tr valign=top><td><a href="p.php?q=Wolli+Creek, NSW">Wolli Creek</a></td><td align=right><a href="his_price.php?q=Wolli+Creek&sta=nsw" style="color:black;text-decoration:none" title="280% higher than last year, click to view more">$3,204,000 <img src="/img/up.gif" border=0></a></td></tr></table><div style="height:15px"></div><a href="subscribe.php?region=Marrickville&sta=nsw"><font style="font-size:14px">Subscribe latest sold prices</font></a><img src="/img/email.gif" border=0></div><div style="height:15px"></div><a href="profile.php?q=Marrickville&sta=nsw"><font style="font-size:14px">Marrickville 2204 Profile</font></a></div><div style="height:15px"></div><a href="rp.php?q=Marrickville&sta=nsw"><font style="font-size:14px">Marrickville rent price</font></a></div><div style="height:15px"></div><a href="newp.php?q=Marrickville&sta=nsw"><font style="font-size:14px">New houses in Marrickville</font></a></div></td><td><div style="border-left:1px solid #d3e1f9;border-top:1px solid #d3e1f9;clear:both"><div id="setFilter" style="margin-left:20px;margin-top:10px;margin-bottom:10px;font-size:16px;-webkit-text-size-adjust:130%"><a href=# onclick="showFilter();return false">+ Set search filters and sorting</a></div><table cellspacing=6 id="filter" style="margin-left:15px;display:none;font-size:14px"><tr valign=center><td>Sort by:</td><td><select id="sort" style="background:#fff"><option value="1">Sale Date&darr;</option><option value="2">Price&darr;</option><option value="3">Price&uarr;</option></select></td></tr><tr valign=center><td>Property type:</td><td><select id="houseType" style="background:#fff"><option value="">All type</option><option value="House">House</option><option value="Townhouse">Townhouse</option><option value="Unit">Unit</option><option value="Apartment">Apartment</option><option value="Land">Land</option><option value="Commercial">Commercial</option></select></td></tr><tr valign=center><td>Bedroom:</td><td><input id="minBed" value="" size=12 style="background:#fff"> - <input id="maxBed" value="" size=12 style="background:#fff"></tr><tr valign=center><td>Price range:</td><td><input id="minPrice" value="" size=12 style="background:#fff"> - <input id="maxPrice" value="" size=12 style="background:#fff"></tr><tr valign=center><td>Address keyword:</td><td><input id="street" value="" size=30 style="background:#fff"></td></tr><tr><td><input type=button value="Filter results" onClick="filter()" style="margin-top:8px;height:27px;font:15px arial,sans-serif bold">&nbsp;&nbsp;<a href=# onclick="showFilter();return false">Hide it</a></td></tr></table><div style="margin-left:5px"><script>google_ad_client="ca-pub-0330993364398838";google_ad_height=60;google_ad_slot="8126171778";google_ad_width=468;</script><script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script></div><table width=100% cellspacing=7 style="font-size:16px" id="r1749774"><tr valign=top><td width=172 align=center><a href="house_img.php?sta=nsw&id=1749774&addr=14%2F345+Illawarra+Road&region=Marrickville&img=11" target=_blank title="Click to view more photos"><img src="/img/nsw/174/17497/1749774.jpg" border=0></a><br/><center style="font-size:13px"><a href="house_img.php?sta=nsw&id=1749774&addr=14%2F345+Illawarra+Road&region=Marrickville&img=11" target=_blank>More Photos</a></center></td><td><table cellspacing=0 cellpadding=0><tr valign=center><td><span class=mark>A</span><span class="addr"><a href="p.php?q=Marrickville&sta=nsw&id=1749774" target=_blank>14/345 Illawarra Road</a></span></td></tr><tr><td><table width=100% style="font-size:13px"><tr><td><b>Sold $650,000</b> in Jul 2014</td></tr><tr><td><b>Unit:</b> 2 <img src="/img/bed.png" border=0 alt="Bed rooms" title="Bed rooms"> 1 <img src="/img/bath.png" border=0 alt="Bath rooms" title="Bath rooms"> 1 <img src="/img/car.png" border=0 alt="Car spaces" title="Car spaces"></td></tr><tr><td><b>Land size:</b> 1,421 sqm</td></tr><tr><td><b>Agent:</b> Richardson & Wrench Marrickville</td></tr><tr><td>SOLD $650,000 RICHARD PERRY - 0418 863 969. Andrew Knox 0425 230 650 Richard Perry 0418 863 969 Quiet, Large and Centrally Located Modern and large 2nd floor 2 bedroom apartment (121 sqm total &...<a href="p.php?q=Marrickville&sta=nsw&id=1749774" target=_blank>more</a></td></tr><tr><td><a href="floorplan.php?addr=14%2F345+Illawarra+Road&q=Marrickville&sta=nsw&img=11&id=1749774&has_img=2" target=_blank>Floorplan</a> | <a href=# onClick="showStreetView(0);return false">Street view</a> | <a href="p.php?q=14%2F345+Illawarra+Road, Marrickville NSW, Australia&lat=-33.9128948&lng=151.1542572" title="Search nearby house sold prices">Nearby</a></td></tr></table></td></tr></table></td></tr></table><center><table width=95% border=0 cellspacing=0 cellpadding=0 class="line" style="margin-top:3px"><tr><td></td></tr></table></center><table width=100% cellspacing=7 style="font-size:16px" id="r30250"><tr valign=top><td width=172 align=center><a href="house_img.php?sta=nsw&id=30250&addr=26%2F345-357+Illawarra+Road&region=Marrickville&img=11" target=_blank title="Click to view more photos"><img src="/img/nsw/3/302/30250.jpg" border=0></a><br/><center style="font-size:13px"><a href="house_img.php?sta=nsw&id=30250&addr=26%2F345-357+Illawarra+Road&region=Marrickville&img=11" target=_blank>More Photos</a></center></td><td><table cellspacing=0 cellpadding=0><tr valign=center><td><span class=mark>B</span><span class="addr"><a href="p.php?q=Marrickville&sta=nsw&id=30250" target=_blank>26/345-357 Illawarra Road</a></span></td></tr><tr><td><table width=100% style="font-size:13px"><tr><td><b>Sold $715,000</b> in Jul 2014</td></tr><tr><td><b>Last Sold</b> $456,500 in Jul 2010</td></tr><tr><td><b>Apartment:</b> 2 <img src="/img/bed.png" border=0 alt="Bed rooms" title="Bed rooms"> 1 <img src="/img/bath.png" border=0 alt="Bath rooms" title="Bath rooms"> 1 <img src="/img/car.png" border=0 alt="Car spaces" title="Car spaces"></td></tr><tr><td><b>Building size:</b> 109 sqm</td></tr><tr><td><b>Agent:</b> Ee Real Estate</td></tr><tr><td>COSMOPOLITAN POSITION. Perfectly located in a great walk-to-everywhere address, this lovingly renovated and impeccably maintained top floor apartment in a low rise security complex is sure to...<a href="p.php?q=Marrickville&sta=nsw&id=30250" target=_blank>more</a></td></tr><tr><td><a href="floorplan.php?addr=26%2F345-357+Illawarra+Road&q=Marrickville&sta=nsw&img=11&id=30250&has_img=2" target=_blank>Floorplan</a> | <a href=# onClick="showStreetView(1);return false">Street view</a> | <a href="p.php?q=26%2F345-357+Illawarra+Road, Marrickville NSW, Australia&lat=-33.912865&lng=151.154228" title="Search nearby house sold prices">Nearby</a></td></tr></table></td></tr></table></td></tr></table><center><table width=95% border=0 cellspacing=0 cellpadding=0 class="line" style="margin-top:3px"><tr><td></td></tr></table></center><table width=100% cellspacing=7 style="font-size:16px" id="r1749199"><tr valign=top><td width=172 align=center><a href="house_img.php?sta=nsw&id=1749199&addr=247+Livingstone+Road&region=Marrickville&img=11" target=_blank title="Click to view more photos"><img src="/img/nsw/174/17491/1749199.jpg" border=0></a><br/><center style="font-size:13px"><a href="house_img.php?sta=nsw&id=1749199&addr=247+Livingstone+Road&region=Marrickville&img=11" target=_blank>More Photos</a></center></td><td><table cellspacing=0 cellpadding=0><tr valign=center><td><span class=mark>C</span><span class="addr"><a href="p.php?q=Marrickville&sta=nsw&id=1749199" target=_blank>247 Livingstone Road</a></span></td></tr><tr><td><table width=100% style="font-size:13px"><tr><td><b>Sold $1,087,000</b> in 19 Jul 2014(Auction)</td></tr><tr><td><b>House:</b> 3 <img src="/img/bed.png" border=0 alt="Bed rooms" title="Bed rooms"> 2 <img src="/img/bath.png" border=0 alt="Bath rooms" title="Bath rooms"> 2 <img src="/img/car.png" border=0 alt="Car spaces" title="Car spaces"></td></tr><tr><td><b>Land size:</b> 204 sqm</td></tr><tr><td><b>Agent:</b> Richardson & Wrench - Marrickville</td></tr><tr><td>Contemporary Living!. RICHARD PERRY 0418 863 969 This contemporary renovated 3 bedroom home, carefully upholding classic period details throughout flows with extensive open plan living areas, all...<a href="p.php?q=Marrickville&sta=nsw&id=1749199" target=_blank>more</a></td></tr><tr><td><a href="floorplan.php?addr=247+Livingstone+Road&q=Marrickville&sta=nsw&img=11&id=1749199&has_img=2" target=_blank>Floorplan</a> | <a href=# onClick="showStreetView(2);return false">Street view</a> | <a href="p.php?q=247+Livingstone+Road, Marrickville NSW, Australia&lat=-33.912539&lng=151.147056" title="Search nearby house sold prices">Nearby</a></td></tr></table></td></tr></table></td></tr></table><center><table width=95% border=0 cellspacing=0 cellpadding=0 class="line" style="margin-top:3px"><tr><td></td></tr></table></center><table width=100% cellspacing=7 style="font-size:16px" id="r1747938"><tr valign=top><td width=172 align=center><a href="house_img.php?sta=nsw&id=1747938&addr=25%2F2-4+Wrights+Avenue&region=Marrickville&img=11" target=_blank title="Click to view more photos"><img src="/img/nsw/174/17479/1747938.jpg" border=0></a><br/><center style="font-size:13px"><a href="house_img.php?sta=nsw&id=1747938&addr=25%2F2-4+Wrights+Avenue&region=Marrickville&img=11" target=_blank>More Photos</a></center></td><td><table cellspacing=0 cellpadding=0><tr valign=center><td><span class=mark>D</span><span class="addr"><a href="p.php?q=Marrickville&sta=nsw&id=1747938" target=_blank>25/2-4 Wrights Avenue</a></span></td></tr><tr><td><table width=100% style="font-size:13px"><tr><td><b>Sold $475,000</b> in 19 Jul 2014(Auction)</td></tr><tr><td><b>List</b> over $440,000</td></tr><tr><td><b>Rent</b> $430pw in Mar 2013</td></tr><tr><td><b>Unit:</b> 2 <img src="/img/bed.png" border=0 alt="Bed rooms" title="Bed rooms"> 1 <img src="/img/bath.png" border=0 alt="Bath rooms" title="Bath rooms"> 1 <img src="/img/car.png" border=0 alt="Car spaces" title="Car spaces"></td></tr><tr><td><b>Land size:</b> 2,275 sqm | <b>Building size:</b> 63 sqm</td></tr><tr><td><b>Agent:</b> Raine & Horne - Petersham</td></tr><tr><td>NEW BLOCK RECORD ST BY JACK FONTANA. Pleasantly positioned at the rear of a well maintained building, this well presented apartment holds tremendous appeal for first homebuyers and investors alike...<a href="p.php?q=Marrickville&sta=nsw&id=1747938" target=_blank>more</a></td></tr><tr><td><a href="floorplan.php?addr=25%2F2-4+Wrights+Avenue&q=Marrickville&sta=nsw&img=11&id=1747938&has_img=2" target=_blank>Floorplan</a> | <a href=# onClick="showStreetView(3);return false">Street view</a> | <a href="p.php?q=25%2F2-4+Wrights+Avenue, Marrickville NSW, Australia&lat=-33.913633&lng=151.147402" title="Search nearby house sold prices">Nearby</a></td></tr></table></td></tr></table></td></tr></table><center><table width=95% border=0 cellspacing=0 cellpadding=0 class="line" style="margin-top:3px"><tr><td></td></tr></table></center><table width=100% cellspacing=7 style="font-size:16px" id="r1747937"><tr valign=top><td width=172 align=center><a href="house_img.php?sta=nsw&id=1747937&addr=6%2F39-43+Riverside+Crescent&region=Marrickville&img=1" target=_blank title="Click to view more photos"><img src="/img/nsw/174/17479/1747937.jpg" border=0></a><br/><center style="font-size:13px"><a href="house_img.php?sta=nsw&id=1747937&addr=6%2F39-43+Riverside+Crescent&region=Marrickville&img=1" target=_blank>More Photos</a></center></td><td><table cellspacing=0 cellpadding=0><tr valign=center><td><span class=mark>E</span><span class="addr"><a href="p.php?q=Marrickville&sta=nsw&id=1747937" target=_blank>6/39-43 Riverside Crescent</a></span></td></tr><tr><td><table width=100% style="font-size:13px"><tr><td><b>Sold $765,000</b> in 19 Jul 2014(Auction)</td></tr><tr><td><b>Townhouse:</b> 3 <img src="/img/bed.png" border=0 alt="Bed rooms" title="Bed rooms"> 2 <img src="/img/bath.png" border=0 alt="Bath rooms" title="Bath rooms"> 1 <img src="/img/car.png" border=0 alt="Car spaces" title="Car spaces"></td></tr><tr><td><b>Land size:</b> 1,630 sqm</td></tr><tr><td><b>Agent:</b> Laing + Simmons Campsie</td></tr><tr><td>AUCTION ON-SITE THIS SATURDAY @ 12pm. LOOK NO FURTHER, LAST CHANCE ! Inspection: Thursday 6:00pm -6.30pm Saturday 11:00am - 11:50am Enjoying quiet & privacy is this newly renovated stylish...<a href="p.php?q=Marrickville&sta=nsw&id=1747937" target=_blank>more</a></td></tr><tr><td><a href=# onClick="showStreetView(4);return false">Street view</a> | <a href="p.php?q=6%2F39-43+Riverside+Crescent, Marrickville NSW, Australia&lat=-33.914246&lng=151.13963" title="Search nearby house sold prices">Nearby</a></td></tr></table></td></tr></table></td></tr></table><center><table width=95% border=0 cellspacing=0 cellpadding=0 class="line" style="margin-top:3px"><tr><td></td></tr></table></center><table width=100% cellspacing=7 style="font-size:16px" id="r1747936"><tr valign=top><td width=172 align=center><a href="house_img.php?sta=nsw&id=1747936&addr=54+Arthur+Street&region=Marrickville&img=11" target=_blank title="Click to view more photos"><img src="/img/nsw/174/17479/1747936.jpg" border=0></a><br/><center style="font-size:13px"><a href="house_img.php?sta=nsw&id=1747936&addr=54+Arthur+Street&region=Marrickville&img=11" target=_blank>More Photos</a></center></td><td><table cellspacing=0 cellpadding=0><tr valign=center><td><span class=mark>F</span><span class="addr"><a href="p.php?q=Marrickville&sta=nsw&id=1747936" target=_blank>54 Arthur Street</a></span></td></tr><tr><td><table width=100% style="font-size:13px"><tr><td><b>Sold $940,000</b> in 19 Jul 2014(Auction)</td></tr><tr><td><b>House:</b> 3 <img src="/img/bed.png" border=0 alt="Bed rooms" title="Bed rooms"> 1 <img src="/img/bath.png" border=0 alt="Bath rooms" title="Bath rooms"> </td></tr><tr><td><b>Land size:</b> 345 sqm</td></tr><tr><td><b>Agent:</b> First National - Iskandar</td></tr><tr><td>"Great size land and home 345smq" AUCTION TODAY !!!!!. Perfectly located just footsteps to Illawarra Road, this character filled home features generous interiors with a large secluded garden. The...<a href="p.php?q=Marrickville&sta=nsw&id=1747936" target=_blank>more</a></td></tr><tr><td><a href="floorplan.php?addr=54+Arthur+Street&q=Marrickville&sta=nsw&img=11&id=1747936&has_img=2" target=_blank>Floorplan</a> | <a href=# onClick="showStreetView(5);return false">Street view</a> | <a href="p.php?q=54+Arthur+Street, Marrickville NSW, Australia&lat=-33.911849&lng=151.15015" title="Search nearby house sold prices">Nearby</a></td></tr></table></td></tr></table></td></tr></table><center><table width=95% border=0 cellspacing=0 cellpadding=0 class="line" style="margin-top:3px"><tr><td></td></tr></table></center><table width=100% cellspacing=7 style="font-size:16px" id="r1747686"><tr valign=top><td width=172 align=center><a href="house_img.php?sta=nsw&id=1747686&addr=100%2F18+Cecilia+Street&region=Marrickville&img=7" target=_blank title="Click to view more photos"><img src="/img/nsw/174/17476/1747686.jpg" border=0></a><br/><center style="font-size:13px"><a href="house_img.php?sta=nsw&id=1747686&addr=100%2F18+Cecilia+Street&region=Marrickville&img=7" target=_blank>More Photos</a></center></td><td><table cellspacing=0 cellpadding=0><tr valign=center><td><span class=mark>G</span><span class="addr"><a href="p.php?q=Marrickville&sta=nsw&id=1747686" target=_blank>100/18 Cecilia Street</a></span></td></tr><tr><td><table width=100% style="font-size:13px"><tr><td><b>Sold $506,000</b> in Jul 2014</td></tr><tr><td><b>Unit:</b> 1 <img src="/img/bed.png" border=0 alt="Bed rooms" title="Bed rooms"> 1 <img src="/img/bath.png" border=0 alt="Bath rooms" title="Bath rooms"> 1 <img src="/img/car.png" border=0 alt="Car spaces" title="Car spaces"></td></tr><tr><td><b>Land size:</b> 8,611 sqm</td></tr><tr><td><b>Agent:</b> Ray White - Dulwich Hill</td></tr><tr><td>Fresh, over-sized and inviting lifestyle apartment. Outstanding in its proportions and providing a fresh and inviting vibe, this top floor apartment combines a peaceful and leafy setting with...<a href="p.php?q=Marrickville&sta=nsw&id=1747686" target=_blank>more</a></td></tr><tr><td><a href="floorplan.php?addr=100%2F18+Cecilia+Street&q=Marrickville&sta=nsw&img=7&id=1747686&has_img=2" target=_blank>Floorplan</a> | <a href=# onClick="showStreetView(6);return false">Street view</a> | <a href="p.php?q=100%2F18+Cecilia+Street, Marrickville NSW, Australia&lat=-33.90826&lng=151.155562" title="Search nearby house sold prices">Nearby</a></td></tr></table></td></tr></table></td></tr></table><center><table width=95% border=0 cellspacing=0 cellpadding=0 class="line" style="margin-top:3px"><tr><td></td></tr></table></center><table width=100% cellspacing=7 style="font-size:16px" id="r1749198"><tr valign=top><td width=172 align=center><a href="house_img.php?sta=nsw&id=1749198&addr=5+Byrnes+Street&region=Marrickville&img=7" target=_blank title="Click to view more photos"><img src="/img/nsw/174/17491/1749198.jpg" border=0></a><br/><center style="font-size:13px"><a href="house_img.php?sta=nsw&id=1749198&addr=5+Byrnes+Street&region=Marrickville&img=7" target=_blank>More Photos</a></center></td><td><table cellspacing=0 cellpadding=0><tr valign=center><td><span class=mark>H</span><span class="addr"><a href="p.php?q=Marrickville&sta=nsw&id=1749198" target=_blank>5 Byrnes Street</a></span></td></tr><tr><td><table width=100% style="font-size:13px"><tr><td><b>Sold $1,530,000</b> in 16 Jul 2014(Auction)</td></tr><tr><td><b>House:</b> 4 <img src="/img/bed.png" border=0 alt="Bed rooms" title="Bed rooms"> 1 <img src="/img/bath.png" border=0 alt="Bath rooms" title="Bath rooms"> 2 <img src="/img/car.png" border=0 alt="Car spaces" title="Car spaces"></td></tr><tr><td><b>Land size:</b> 525 sqm</td></tr><tr><td><b>Agent:</b> Raine & Horne - Marrickville</td></tr><tr><td>Deceased Estate – Renovate and Restore. Tightly held for over fifty years, this double fronted federation home presents a rare opportunity. In need of restoration, the property features plenty...<a href="p.php?q=Marrickville&sta=nsw&id=1749198" target=_blank>more</a></td></tr><tr><td><a href="floorplan.php?addr=5+Byrnes+Street&q=Marrickville&sta=nsw&img=7&id=1749198&has_img=2" target=_blank>Floorplan</a> | <a href=# onClick="showStreetView(7);return false">Street view</a> | <a href="p.php?q=5+Byrnes+Street, Marrickville NSW, Australia&lat=-33.913082&lng=151.154612" title="Search nearby house sold prices">Nearby</a></td></tr></table></td></tr></table></td></tr></table><center><table width=95% border=0 cellspacing=0 cellpadding=0 class="line" style="margin-top:3px"><tr><td></td></tr></table></center><table width=100% cellspacing=7 style="font-size:16px" id="r1747995"><tr valign=top><td width=172 align=center><img src="http://cbk0.google.com/cbk?output=thumbnail&w=160&h=130&ll=-33.900274,151.155407" border=0></td><td><table cellspacing=0 cellpadding=0><tr valign=center><td><span class=mark>I</span><span class="addr"><a href="p.php?q=Marrickville&sta=nsw&id=1747995" target=_blank>41/1-3 Coronation Avenue</a></span></td></tr><tr><td><table width=100% style="font-size:13px"><tr><td><b>Sold $751,000</b> in 16 Jul 2014(Auction)</td></tr><tr><td><b>Unit:</b> 2 <img src="/img/bed.png" border=0 alt="Bed rooms" title="Bed rooms"> 2 <img src="/img/bath.png" border=0 alt="Bath rooms" title="Bath rooms"> 1 <img src="/img/car.png" border=0 alt="Car spaces" title="Car spaces"></td></tr><tr><td><a href=# onClick="showStreetView(8);return false">Street view</a> | <a href="p.php?q=41%2F1-3+Coronation+Avenue, Marrickville NSW, Australia&lat=-33.900274&lng=151.155407" title="Search nearby house sold prices">Nearby</a></td></tr></table></td></tr></table></td></tr></table><center><table width=95% border=0 cellspacing=0 cellpadding=0 class="line" style="margin-top:3px"><tr><td></td></tr></table></center><table width=100% cellspacing=7 style="font-size:16px" id="r1747994"><tr valign=top><td width=172 align=center><img src="http://cbk0.google.com/cbk?output=thumbnail&w=160&h=130&ll=-33.9050945,151.1596735" border=0></td><td><table cellspacing=0 cellpadding=0><tr valign=center><td><span class=mark>J</span><span class="addr"><a href="p.php?q=Marrickville&sta=nsw&id=1747994" target=_blank>8 Holmsdale Street</a></span></td></tr><tr><td><table width=100% style="font-size:13px"><tr><td><b>Sold $1,405,000</b> in 16 Jul 2014(Auction)</td></tr><tr><td><b>Terrace:</b> 4 <img src="/img/bed.png" border=0 alt="Bed rooms" title="Bed rooms"> 2 <img src="/img/bath.png" border=0 alt="Bath rooms" title="Bath rooms"> 1 <img src="/img/car.png" border=0 alt="Car spaces" title="Car spaces"></td></tr><tr><td><a href=# onClick="showStreetView(9);return false">Street view</a> | <a href="p.php?q=8+Holmsdale+Street, Marrickville NSW, Australia&lat=-33.9050945&lng=151.1596735" title="Search nearby house sold prices">Nearby</a></td></tr></table></td></tr></table></td></tr></table><script>
    var searchLat=0,searchLng=0,query="Marrickville",state="nsw",agent=0,region="Marrickville",browserType=0,hid=0,htype="",stateName="New South Wales",sumlat=-339.1047373,sumlong=1511.5179777,marktotal=10,latlong=new Array(-33.9128948,151.1542572,-33.912865,151.154228,-33.912539,151.147056,-33.913633,151.147402,-33.914246,151.13963,-33.911849,151.15015,-33.90826,151.155562,-33.913082,151.154612,-33.900274,151.155407,-33.9050945,151.1596735),latids=new Array(1749774,30250,1749199,1747938,1747937,1747936,1747686,1749198,1747995,1747994);
    var a,pos,scriptObj,scrollPos,mapLat,mapLong,mapScript,zoom=13;
    function filter()
    {
      var s,str,t,minp,maxp,minb,maxb;
      s=document.getElementById("sort").value;
      if(s!=0 && searchLat!=0)
      {
        searchLat=0;searchLng=0;
      }
      str=document.getElementById("street").value;
      t=document.getElementById("houseType").value;
      minp=document.getElementById("minPrice").value;
      maxp=document.getElementById("maxPrice").value;
      minb=document.getElementById("minBed").value;
      maxb=document.getElementById("maxBed").value;
      window.location.href='p.php?q='+query+"&s="+s+"&st="+str+"&type="+t+
    "&region="+region+"&lat="+searchLat+"&lng="+searchLng+"&sta="+state+"&htype="+htype+"&agent="+agent+
    "&minprice="+minp+"&maxprice="+maxp+"&minbed="+minb+"&maxbed="+maxb;
      return false;
    }
    function showFilter()
    {
      if(document.getElementById("filter").style.display=='none')
      {
        document.getElementById("setFilter").style.display='none';
        document.getElementById("filter").style.display='';
      }
      else
      {
        document.getElementById("setFilter").style.display='';
        document.getElementById("filter").style.display='none';
      }
    }
    function setupMap()
    {
      if(document.getElementById("map"))
      {
        if(a)
        {
          delete a;
        }
        a=new Array();
        pos=0;
        if(searchLat != 0 && searchLng != 0)
        {
          var max=0,dist;
          for(n=0; n<marktotal; ++n)
          {
            dist=Math.max(Math.abs(latlong[n*2]-searchLat),Math.abs(latlong[n*2+1]-searchLng));
            if(dist > max)
            {
              max=dist;
            }
          }
          if(max < 0.0025)
          {
            zoom=16;
          }
          else if(max < 0.005)
          {
            zoom=15;
          }
          else if(max < 0.01)
          {
            zoom=14;
          }
          a[pos++]='<a href=# onClick="zoomMap();return false"><img src="http://maps.google.com/maps/api/staticmap?zoom='+zoom+'&size='+ 
          parseInt(document.getElementById("map").style.width)+'x360&sensor=false&language=en&center='+searchLat+','+searchLng;
        }
        else if(marktotal==0)
        {
          a[pos++]='<a href=# onClick="zoomMap();return false"><img src="http://maps.google.com/maps/api/staticmap?zoom=13&size=' + 
          parseInt(document.getElementById("map").style.width) + 'x360&sensor=false&language=en&center='+region+','+stateName+',australia';
        }
        else
        {
          a[pos++]='<a href=# onClick="zoomMap();return false"><img src="http://maps.google.com/maps/api/staticmap?zoom=13&size=' +
          parseInt(document.getElementById("map").style.width)+'x'+parseInt(document.getElementById("map").style.height)+
          '&sensor=false&language=en&center='+(sumlat/marktotal+0.001200)+','+(sumlong/marktotal);
        }
        if(searchLat != 0 && searchLng != 0)
        {
          a[pos++]="&markers=label:X|"+searchLat+","+searchLng;
        }
        for(n=0;n<marktotal;++n)
        {
          a[pos++]="&markers=label:"+String.fromCharCode(65+n)+"|"+latlong[n*2]+","+latlong[n*2+1];
        }
        a[pos]='" border=0 title="Click to navigate the map"></a>';
        document.getElementById("map").innerHTML=a.join("");
        if(marktotal > 0 && hid==0)
        {
          document.getElementById("zoomMapTips").innerHTML='<a href=# onClick="zoomMap();return false"><font style="font-size:12px">Navigate the map</font></a>';
        }
        else
        {
          document.getElementById("zoomMapTips").innerHTML='';
        }
      }
    }
    function rectify()
    {
      document.getElementById("tips").innerHTML='<font style="font-size:12px">Please fill the sold price and date, and submit</font>';
      document.getElementById("comment").innerHTML="Price: $\nDate: ";
    }
    function showDlg(dlgWidth)
    {
      if(document.documentElement && document.documentElement.scrollTop)
      {
            scrollPos = document.documentElement.scrollTop;
        }
        else if(window.pageYOffset)
        {
          scrollPos = window.pageYOffset;
        }
      else
      {
        scrollPos = document.body.scrollTop;
      }
      var pageHeight;
      if(document.documentElement.clientWidth)
      {
        pageHeight = document.documentElement.scrollHeight;
      }
      else
      {
        pageHeight = document.body.scrollHeight;
      }
      var dlg = document.getElementById("dlgBack");
      dlg.style.display="";
      dlg.style.top=(scrollPos+20)+"px";
      dlg.style.left = (browserWidth / 2 - parseInt(dlgWidth)/2 + 5) + "px";
      dlg.style.height = (browserHeight - 40) + "px";
      dlg.style.width = dlgWidth;

      dlg = document.getElementById("dlgBack1");
      dlg.style.display="";
      dlg.style.top="0px";
      dlg.style.height = pageHeight + "px";
      dlg.style.width = browserWidth + "px";

      dlg = document.getElementById("dlg");
      dlg.style.display="";
      dlg.style.top=(scrollPos+20)+"px";
      dlg.style.left = (browserWidth / 2 - parseInt(dlgWidth)/2) + "px";
      dlg.style.height = (browserHeight - 40) + "px";
      dlg.style.width = dlgWidth;
    }
    function closeDlg()
    {
      if(document.getElementById("show").style.display == '')
        return;
      if(document.getElementById("map_canvas").style.display == '')
      {
        document.getElementById("map_canvas").style.display='none';
        document.body.removeChild(mapScript);
      }
      document.getElementById("dlgContent").innerHTML = '';
      document.getElementById("dlgBack").style.display="none";
      document.getElementById("dlgBack1").style.display="none";
      document.getElementById("dlg").style.display="none";
    }
    function showWait()
    {
      var pageHeight;
      if(document.documentElement.clientWidth)
      {
        pageHeight = document.documentElement.scrollHeight;
      }
      else
      {
        pageHeight = document.body.scrollHeight;
      }
      scrollPos=0;
      dlgWidth=800;
      dlgHeight=400;
      var dlg = document.getElementById("dlgBack1");
      dlg.style.display="";
      dlg.style.top=scrollPos+"px";
      dlg.style.height = pageHeight + "px";
      dlg.style.width = browserWidth + "px";

      dlg = document.getElementById("dlgBack");
      dlg.style.display="";
      dlg.style.top=(scrollPos+100)+"px";
      dlg.style.left = (browserWidth / 2 - parseInt(dlgWidth)/2) + 5 + "px";
      dlg.style.height = dlgHeight + "px";
      dlg.style.width = dlgWidth + "px";

      dlg = document.getElementById("show");
      dlg.style.display="";
      dlg.style.top=(scrollPos+100)+"px";
      dlg.style.left = (browserWidth / 2 - parseInt(dlgWidth)/2) + "px";
      dlg.style.height = dlgHeight + "px";
      dlg.style.width = dlgWidth + "px";
      
      dlg = document.getElementById("showFrame");
      dlg.style.height = dlgHeight + "px";
      dlg.style.width = dlgWidth + "px";
      window.frames['showFrame'].location.href="showtime.php?type=1";
    }
    function initializeMap() 
    {
      var myLatlng = new google.maps.LatLng(mapLat, mapLong);
      var myOptions = {
        zoom:15,
        center: myLatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      }
      var obj=document.getElementById("map_canvas");
      obj.style.display = '';
      obj.style.width = '740px';
      obj.style.height = (parseInt(document.getElementById("dlgBack").style.height) - 70) + 'px';
      var map = new google.maps.Map(obj, myOptions);

      var marker = new google.maps.Marker({
          position:myLatlng
      });
      marker.setMap(map);
    }
    function showMap(pos)
    {
      showDlg("750px");
      document.getElementById("dlgTitle").innerHTML=getAddr(pos);
      mapLat = latlong[pos*2];
      mapLong = latlong[pos*2+1];
      mapScript = document.createElement("script");
      mapScript.type = "text/javascript";
      mapScript.src = "http://maps.google.com/maps/api/js?sensor=false&callback=initializeMap&language=en";
      document.body.appendChild(mapScript);
      document.getElementById("dlgContent").innerHTML = '<center><a href=# onClick="closeDlg();showStreetView('+pos+');return false">Show house street view</a></center>';
    }
    function initializeStreet() 
    {
        var bryantPark = new google.maps.LatLng(mapLat, mapLong);
        var panoramaOptions = {
          position:bryantPark,
          pov: {
            heading:165,
            pitch:0,
            zoom:1
          }
        };
        var obj=document.getElementById("map_canvas");
      obj.style.display = '';
      obj.style.width = '740px';
      obj.style.height = (parseInt(document.getElementById("dlgBack").style.height) - 70) + 'px';
        var myPano = new google.maps.StreetViewPanorama(obj, panoramaOptions);
        myPano.setVisible(true);
    }
    function showStreetView(pos)
    {
      showDlg("750px");
      document.getElementById("dlgTitle").innerHTML=getAddr(pos);
      mapLat = latlong[pos*2];
      mapLong = latlong[pos*2+1];
      mapScript = document.createElement("script");
      mapScript.type = "text/javascript";
      mapScript.src = "http://maps.google.com/maps/api/js?sensor=false&callback=initializeStreet&language=en";
      document.body.appendChild(mapScript);
      document.getElementById("dlgContent").innerHTML = '<center><a href=# onClick="closeDlg();showMap('+pos+');return false">Show house location map</a></center>';
    }
    var infoWindow;
    function initializeZoomMap() 
    {
      var myLatlng;
      if(searchLat != 0 && searchLng != 0)
      {
        myLatlng = new google.maps.LatLng(searchLat, searchLng);
      }
      else
      {
        myLatlng = new google.maps.LatLng((sumlat/marktotal+0.001200), (sumlong/marktotal));
      }
      var myOptions = {
        zoom:zoom,
        center: myLatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      }
      var obj=document.getElementById("map_canvas");
      obj.style.display = '';
      obj.style.width = '740px';
      obj.style.height = (parseInt(document.getElementById("dlgBack").style.height) - 70) + 'px';
      var map = new google.maps.Map(obj, myOptions);
      var markLatlng, marker;
      for(n=0;n<marktotal;++n)
      {
        markLatlng = new google.maps.LatLng(latlong[n*2],latlong[n*2+1]);
        marker = createMarker(markLatlng, map, n);
      }
      if(searchLat != 0 && searchLng != 0)
      {
        markLatlng = new google.maps.LatLng(searchLat, searchLng);
        createMarker(markLatlng, map, 99);
      }
    }
    function getAddr(n)
    {
      if(hid>0)
      {
        return('');
      }
      var s=document.getElementById('r'+latids[n]).innerHTML,t='',p,p1,t='';
      p=s.indexOf('class="addr');
      if(p>0)
      {
        p=s.indexOf("<",p);
        p1=s.indexOf("</",p);
        if(p>0&&p1>0)
        {
          t=s.substring(p,p1);
          p=t.indexOf('>');
          if(p>0)
          {
            p++;
            t=t.substring(p);
          }
        }
      }
      return(t);
    }
    function createMarker(point, map, n)
    {
      if(n == 99)
      {
        var marker = new google.maps.Marker({
            position:point,
            title:"Search location: "+query
        });
        marker.setMap(map);
      }
      else
      {
        t=getAddr(n);
        var marker = new google.maps.Marker({
            position:point,
            title:t
        });
        marker.setMap(map);
        if(hid==0)
        {
          google.maps.event.addListener(marker, 'click', function() {
            if(infoWindow) infoWindow.close();
              infoWindow = new google.maps.InfoWindow({content:'<table cellspacing=7 style="font-size:16px">'+
              document.getElementById('r'+latids[n]).innerHTML+'</table>'});
            infoWindow.open(map, marker);
          });
        }
      }
      return(marker);
    }
    function zoomMap()
    {
      if(marktotal==0)
        return;
      showDlg("750px");
      document.getElementById("dlgTitle").innerHTML = region + " Property Locations";
      mapScript = document.createElement("script");
      mapScript.type = "text/javascript";
      mapScript.src = "http://maps.google.com/maps/api/js?sensor=false&callback=initializeZoomMap&language=en";
      document.body.appendChild(mapScript);
    }
    </script></div></td>
    <td width=260><div id="map" style="width:260px;height:360px"></div><center><span id="zoomMapTips"></span></center><div style="height:15px"></div><script type="text/javascript">google_ad_client="ca-pub-0330993364398838";google_ad_slot="5839315468";google_ad_width=160;google_ad_height=600;</script><script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script></td><td width=0></td></tr></table>
    <div id="show" style="display:none;position:absolute;left:10px;top:10px;width:500px;height:400px;background:#FFFFFF;z-index:10;border:1px solid #ccc"><iframe src="" id="showFrame" name="showFrame" style="border:0px"></iframe></div>
    <div id="dlg" style="display:none;position:absolute;left:10px;top:10px;width:500px;height:400px;background:#FFFFFF;z-index:10;border:1px solid #ccc;overflow:auto">
    <table width=100% cellspacing=8><tr><td><b><span id="dlgTitle"></span></b></td>
    <td width=20 align=left><a href=# onClick="closeDlg();return false"><img src="/img/close.png" title="Close" border=0></a></td></table>
    <div id="map_canvas" style="display:none;margin:3px auto 6px"></div>
    <div id="dlgContent"></div>
    <iframe src="" style="display:none;_display:block;position:absolute;top:0;left:0px;z-index:-1;filter:mask();width:500px;height:400px"></iframe>
    </div>
    <div id="dlgBack" style="display:none;z-index:9;position:absolute;top:15px;left:15px;width:500px;height:400px;background-color:#000;opacity:.12;filter:alpha(opacity=12);"></div>
    <div id="dlgBack1" style="display:none;z-index:8;position:absolute;top:0px;left:0px;background-color:#000;opacity:.12;filter:alpha(opacity=12);" onclick="closeDlg()"></div>
    <div style="height:15px"></div>
    <center>
    <table cellspacing=6 style="font-size:16px;-webkit-text-size-adjust:130%"><tr><td><b>1</b></td><td><a href="p.php?q=Marrickville&p=1&s=1&st=&type=&count=1000&region=Marrickville&lat=0&lng=0&sta=nsw&htype=&agent=0&minprice=0&maxprice=0&minbed=0&maxbed=0">2</a></td><td><a href="p.php?q=Marrickville&p=2&s=1&st=&type=&count=1000&region=Marrickville&lat=0&lng=0&sta=nsw&htype=&agent=0&minprice=0&maxprice=0&minbed=0&maxbed=0">3</a></td><td><a href="p.php?q=Marrickville&p=3&s=1&st=&type=&count=1000&region=Marrickville&lat=0&lng=0&sta=nsw&htype=&agent=0&minprice=0&maxprice=0&minbed=0&maxbed=0">4</a></td><td><a href="p.php?q=Marrickville&p=4&s=1&st=&type=&count=1000&region=Marrickville&lat=0&lng=0&sta=nsw&htype=&agent=0&minprice=0&maxprice=0&minbed=0&maxbed=0">5</a></td><td><a href="p.php?q=Marrickville&p=5&s=1&st=&type=&count=1000&region=Marrickville&lat=0&lng=0&sta=nsw&htype=&agent=0&minprice=0&maxprice=0&minbed=0&maxbed=0">6</a></td><td><a href="p.php?q=Marrickville&p=6&s=1&st=&type=&count=1000&region=Marrickville&lat=0&lng=0&sta=nsw&htype=&agent=0&minprice=0&maxprice=0&minbed=0&maxbed=0">7</a></td><td><a href="p.php?q=Marrickville&p=7&s=1&st=&type=&count=1000&region=Marrickville&lat=0&lng=0&sta=nsw&htype=&agent=0&minprice=0&maxprice=0&minbed=0&maxbed=0">8</a></td><td><a href="p.php?q=Marrickville&p=8&s=1&st=&type=&count=1000&region=Marrickville&lat=0&lng=0&sta=nsw&htype=&agent=0&minprice=0&maxprice=0&minbed=0&maxbed=0">9</a></td><td><a href="p.php?q=Marrickville&p=9&s=1&st=&type=&count=1000&region=Marrickville&lat=0&lng=0&sta=nsw&htype=&agent=0&minprice=0&maxprice=0&minbed=0&maxbed=0">10</a></td><td><a href="p.php?q=Marrickville&p=1&s=1&st=&type=&count=1000&region=Marrickville&lat=0&lng=0&sta=nsw&htype=&agent=0&minprice=0&maxprice=0&minbed=0&maxbed=0"><b>Next &gt;&gt;</b></a></td></tr></table></center>
    <div style="margin:10px auto 19px auto;text-align:center">
    <script type="text/javascript">google_ad_client="ca-pub-0330993364398838";google_ad_slot="5233245576";google_ad_width=728;google_ad_height=90;</script><script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script><p style="color:#767676;font-size:9pt">The property data is from the auction results and realestate websites.</p>
    <p style="color:#767676;font-size:9pt">&copy; 2014 - <a href="sitemap.php">sitemap</a> - <a href="/cn/p.php?q=Marrickville&s=1&region=Marrickville&sta=nsw">中文版</a></p>
    </div>
    <script>
    if(browserWidth > 1024&&browserType==0)
    {
      var remain = (browserWidth - 1024) / 2;
      var add = remain;
      if(add > 60)
      {
        add = 60;
      }
      document.getElementById("mainT").rows[0].cells[0].width = parseInt(document.getElementById("mainT").rows[0].cells[0].width) + add;
      add = remain;
      if(add > 150)
      {
        add = 150;
      }
      document.getElementById("mainT").rows[0].cells[2].width = parseInt(document.getElementById("mainT").rows[0].cells[2].width) + add;
      if(document.getElementById("map"))
        document.getElementById("map").style.width=document.getElementById("mainT").rows[0].cells[2].width + "px";
      add = browserWidth - parseInt(document.getElementById("mainT").rows[0].cells[0].width) - 
        parseInt(document.getElementById("mainT").rows[0].cells[2].width) - 700;
      if(add > 0)
      {
        document.getElementById("mainT").rows[0].cells[3].width = add;
      }
    }
    setupMap();
    document.getElementById("sort").value=1;document.getElementById("street").value="";document.getElementById("houseType").value="";
    document.getElementById("q").value=query+", "+state.toUpperCase();
    document.getElementById("head_r").innerHTML=document.getElementById("head_r").innerHTML.replace('rent.php','rent.php?q='+region+", "+state.toUpperCase());
    document.getElementById("head_s").innerHTML=document.getElementById("head_s").innerHTML.replace('suburb.php','suburb.php?q='+region+", "+state.toUpperCase());
    document.getElementById("head_school").innerHTML='<a href="search_school.php?q='+region+", "+state.toUpperCase()+'">School</a>';
    document.getElementById("head_new").innerHTML='<a href="newhome.php?q='+region+", "+state.toUpperCase()+'">New Home</a>';
    var ACscript = document.createElement("script");
    ACscript.type = "text/javascript";
    ACscript.src = "region_auto.js";
    document.body.appendChild(ACscript);
    </script>
    </body></html>
    <script src="ujs.php?r="></script><script>var _gaq=_gaq || [];_gaq.push(["_setAccount", "UA-21356954-1"]);_gaq.push(["_trackPageview"]);(function(){var ga = document.createElement("script"); ga.type = "text/javascript"; ga.async = true;ga.src = ("https:" == document.location.protocol ? "https://ssl" : "http://www") + ".google-analytics.com/ga.js"; var s = document.getElementsByTagName("script")[0];s.parentNode.insertBefore(ga, s);})();</script>
  html
end