```
  ,--./,-.
 / #      \
|          |
 \        /Walgreens API Harvester
  `._,._,'=======================

This tool downloads and stores data from the Walgreens API.
It creates walgreensapidb.sql in ~/Library/Application Support.
This database is transferred to the dashboard app bundle.
See https://github.com/sebastiangarbarek/walgreens-dashboard-app.

Features:
- Download Walgreens store data
- Update inconsistent store data
- Update daily print store status
- Download Walgreens print product data
- Automatic request recovery
- Open, close, reopen and continue

======================================================================

store_detail

storeNum					INT		PRIMARY KEY

location
	address1				TEXT
	address2				TEXT
	street					TEXT
	streetAddr2				TEXT
	city					TEXT
	state					TEXT
	country					TEXT	
	county					TEXT
	districtNum				TEXT
	storeAreaCd				TEXT
	formattedIntersection	TEXT
	intersection			TEXT
	latitude				TEXT
	longitude				TEXT

time
	storeTimeZone			TEXT
	timezone				TEXT	
	dayltTimeOffset			INT		BOOLEAN AS 1 OR 0
	stdTimeOffset			INT		BOOLEAN AS 1 OR 0
	timeOffsetCode			INT		
	twentyFourHr			TEXT	BOOLEAN AS ‘Y’ OR ’N’

status
	photoInd				TEXT	BOOLEAN AS ‘TRUE’ OR ‘FALSE’
	photoStatusCd			TEXT	
	storePhotoStatusCd		TEXT
	inkjeti					TEXT
	storeStatus				TEXT	‘OPEN’ OR ‘CLOSED’

contact
	intlPhoneNumber			TEXT
	storePhoneNum			TEXT

status						INT		BOOLEAN AS 1 OR 0
updateDtTime				TEXT

======================================================================

store_hour

storeNum					INT		PRIMARY KEY

avail						TEXT

hours
	monOpen					TEXT
	monClosed				TEXT
	mon24Hrs				INT		BOOLEAN AS 1 OR 0
	tueOpen					TEXT
	tueClosed				TEXT
	tue24Hrs				INT		BOOLEAN AS 1 OR 0
	wedOpen					TEXT
	wedClosed				TEXT
	wed24Hrs				INT		BOOLEAN AS 1 OR 0
	thuOpen					TEXT
	thuClosed				TEXT
	thu24Hrs				INT		BOOLEAN AS 1 OR 0
	friOpen					TEXT
	friClosed				TEXT
	fri24Hrs				INT		BOOLEAN AS 1 OR 0
	satOpen					TEXT
	satClosed				TEXT
	sat24Hrs				INT		BOOLEAN AS 1 OR 0
	sunOpen					TEXT
	sunClosed				TEXT
	sun24Hrs				INT		BOOLEAN AS 1 OR 0

wkDaySameInd				INT		BOOLEAN AS 1 OR 0
hourType					TEXT		
updateDtTime				TEXT

======================================================================

product_detail

product
	productId				TEXT	PRIMARY KEY
	productGroupId			TEXT
	productDesc				TEXT
	productPrice			TEXT
	currencyType			INT
	productSize				TEXT

sizing
	offsetWidth				TEXT
	offsetHeight			TEXT
	resWidth				TEXT
	resHeight				TEXT
	dpi						TEXT	

other
	multiImageIndicator		TEXT	BOOLEAN AS ‘Y’ OR ’N’
	boxQty					INT
	vendorQtyLimit			TEXT
	templateUrl				TEXT

updateDtTime				TEXT

======================================================================

store_status

storeNum					INT		PRIMARY KEY, FOREIGN KEY
date						TEXT	PRIMARY KEY
status						INT		BOOLEAN AS 1 OR 0
```