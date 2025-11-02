$scraped_page = Invoke-WebRequest -TimeoutSec 10 -Uri http://10.0.17.42/ToBeScraped.html

# Output the count of links in the page
$scraped_page.Links.Count

# Display links as HTML Elements
$scraped_page.Links

# Display only the URL and its Text
$scraped_page.Links | Select-Object outerText, href


# Get out text of every element with h2 tags
$h2s=$scraped_page.ParsedHtml.body.getElementsByTagName("h2") | Select-Object outerText

$h2s

# Display innerText of every div element that has the class as "div-1"
$divs1=$scraped_page.ParsedHtml.body.getElementsByTagName("div") | where { `
$_.getAttributeNode("class").Value -ilike "div-1"} | select innerText 

$divs1
