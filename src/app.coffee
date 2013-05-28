###
Jordi Petit
jordi.petit@gmail.com
###


to_google = (lat, lon) ->
	digits = 10
	symbols = 1

	lat_pos = (if lat >= 0 then "N" else "S")
	lat_deg = Math.abs(lat)
	lat = lat_pos + " " + lat_deg.toFixed(digits) + (symbol "°")

	lon_pos = (if lon >= 0 then "E" else "W")
	lon_deg = Math.abs(lon)
	lon = lon_pos + " " + lon_deg.toFixed(digits) + (symbol "°")

	return lat + " " + lon


to_d = (lat, lon) ->
	digits = slider_value("#slider_d")
	symbols = slider_value("#symbols")

	lat_pos = (if lat >= 0 then "N" else "S")
	lat_deg = Math.abs(lat)
	lat = lat_pos + " " + lat_deg.toFixed(digits) + (symbol "°")

	lon_pos = (if lon >= 0 then "E" else "W")
	lon_deg = Math.abs(lon)
	lon = lon_pos + " " + lon_deg.toFixed(digits) + (symbol "°")

	return lat + " " + lon


to_dm = (lat, lon) ->
	digits = slider_value("#slider_m")
	symbols = slider_value("#symbols")

	lat_pos = (if lat >= 0 then "N" else "S")
	lat = Math.abs(lat)
	lat_deg = Math.floor(lat)
	lat_min = 60 * (lat - lat_deg)
	lat = lat_pos + " " + lat_deg + (symbol "°") + " " + lat_min.toFixed(digits) + (symbol "'")

	lon_pos = (if lon >= 0 then "E" else "W")
	lon = Math.abs(lon)
	lon_deg = Math.floor(lon)
	lon_min = 60 * (lon - lon_deg)
	lon = lon_pos + " " + lon_deg + (symbol "°") + " " + lon_min.toFixed(digits) + (symbol "'")

	return lat + " " + lon


to_dms = (lat, lon) ->
	digits = slider_value("#slider_s")
	symbols = slider_value("#symbols")

	lat_pos = (if lat >= 0 then "N" else "S")
	lat = Math.abs(lat)
	lat_deg = Math.floor(lat)
	lat_min_f = 60 * (lat - lat_deg)
	lat_min_i = Math.floor(lat_min_f)
	lat_sec = 60 * (lat_min_f - lat_min_i)
	lat = lat_pos + " " + lat_deg + (symbol "°") + " " + lat_min_i + (symbol "'") + " " + lat_sec.toFixed(digits) + (symbol "\"")

	lon_pos = (if lon >= 0 then "E" else "W")
	lon = Math.abs(lon)
	lon_deg = Math.floor(lon)
	lon_min_f = 60 * (lon - lon_deg)
	lon_min_i = Math.floor(lon_min_f)
	lon_sec = 60 * (lon_min_f - lon_min_i)
	lon = lon_pos + " " + lon_deg + (symbol "°") + " " + lon_min_i + (symbol "'") + " " + lon_sec.toFixed(digits) + (symbol "\"")

	return lat + " " + lon


to_utm = (lat, lon) ->
	digits = slider_value("#slider_utm")
	symbols = slider_value("#symbols")

	xy = new Array 2
	zone = Math.floor((lon + 180.0) / 6) + 1
	LatLonToUTMXY DegToRad(lat), DegToRad(lon), zone, xy
	emi = (if lat < 0 then "S" else "N")

	return "UTM" + zone + emi + " " + xy[0].toFixed(digits) + (symbol ",") + " " + xy[1].toFixed(digits)


parse = (input) ->
	re = /\s*here\s*/
	m = re.exec(input)
	if m
		print "HERE"
		navigator.geolocation.getCurrentPosition (location) ->
			lat = location.coords.latitude
			lon = location.coords.longitude
			$("#coords").textinput().val to_d(lat, lon)
			$("#coords_d").textinput().val to_d(lat, lon)
			$("#coords_dm").textinput().val to_dm(lat, lon)
			$("#coords_dms").textinput().val to_dms(lat, lon)
			$("#coords_utm").textinput().val to_utm(lat, lon)
			$("#view").button "enable"

		return null


	re = /UTM(\d+)\s*([ns])\s*(\d+)(\s+)(\d+)/
	m = re.exec(input)
	if m
		zone = parseInt m[1]
		emis = m[2]
		posx = parseInt m[3]
		posy = parseInt m[5]
		print "UTM", zone, emis, poss, posy

		latlon = new Array(2)
		UTMXYToLatLon posx, posy, zone, (emis is 's'), latlon
		return (
			lat: RadToDeg latlon[0]
			lon: RadToDeg latlon[1]
		)


	re = /([-+]?\d+(\.(\d+)?)?)\s+([-+]?\d+(\.(\d+)?)?)/
	m = re.exec(input)
	if m
		lat = parseFloat(m[1])
		lon = parseFloat(m[4])

		print "D", lat, lon
		return (
			lat: lat
			lon: lon
		)

	re = /([ns])\s*(\d+\.\d+)\s+([ew])\s*(\d+\.\d+)/
	m = re.exec(input)
	if m
		lat = parseFloat(m[2])
		lon = parseFloat(m[4])
		lat = -lat	if m[1] is "s"
		lon = -lon	if m[3] is "w"
		return (
			lat: lat
			lon: lon
		)

	re = /([ew])\s*(\d+\.\d+)\s+([ns])\s*(\d+\.\d+)/
	m = re.exec(input)
	if m
		lat = parseFloat(m[4])
		lon = parseFloat(m[2])
		lat = -lat	if m[3] is "s"
		lon = -lon	if m[1] is "w"
		return (
			lat: lat
			lon: lon
		)

	return null


view_button = ->
	input = $("#coords").textinput().val().trim().toLowerCase()
	res = parse input
	if res
		window.location = "https://maps.google.com/maps?hl=ca&q=" + to_google(res.lat, res.lon)
	else
		print "cannot parse"


convert_button = ->
	input = $("#coords").textinput().val().trim().toLowerCase()
	res = parse input
	if res
		$("#coords_d").textinput().val to_d(res.lat, res.lon)
		$("#coords_dm").textinput().val to_dm(res.lat, res.lon)
		$("#coords_dms").textinput().val to_dms(res.lat, res.lon)
		$("#coords_utm").textinput().val to_utm(res.lat, res.lon)
		$("#view").button("enable")
	else
		$("#coords_d").textinput().val("")
		$("#coords_dm").textinput().val("")
		$("#coords_dms").textinput().val("")
		$("#coords_utm").textinput().val("")
		$("#view").button("disable")


vell = ->
	loop
		last = utm
		utm = utm.replace("	", " ")
		utm = utm.replace(",", "")
		break	if utm is last
	x = parseFloat(utm.split(" ")[0])
	y = parseFloat(utm.split(" ")[1])
	zone = 31
	southhemi = false
	latlon = new Array(2)
	UTMXYToLatLon x, y, zone, southhemi, latlon
	lat = RadToDeg(latlon[0])
	lon = RadToDeg(latlon[1])
	document.f.gps_d.value = to_d(lat, lon)
	document.f.gps_dm.value = to_dm(lat, lon)
	document.f.gps_dms.value = to_dms(lat, lon)



update = ->
	convert_button()


slider_value = (id) ->
	parseInt $(id).val()


print = (x) ->
	console.log x


symbol = (x) ->
	if slider_value("#symbols") then x else ""

