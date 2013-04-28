to_d = (lat, lon) ->
	if lat >= 0
		lat = "N " + lat.toFixed(6)
	else
		lat = "S " + (-lat.toFixed(6))
	if lon >= 0
		lon = "E " + lon.toFixed(6)
	else
		lon = "W " + (-lon.toFixed(6))
	lat + " " + lon
to_dm = (lat, lon) ->
	lat_deg = Math.floor(lat)
	lat_min = 60 * (lat - lat_deg)
	if lat >= 0
		lat = "N " + lat_deg + " " + lat_min.toFixed(3)
	else
		lat = "S " + (-lat_deg) + " " + (-lat_min.toFixed(3))
	lon_deg = Math.floor(lon)
	lon_min = 60 * (lon - lon_deg)
	if lon >= 0
		lon = "E " + lon_deg + " " + lon_min.toFixed(3)
	else
		lon = "W " + (-lon_deg) + " " + (-lon_min.toFixed(3))
	lat + " " + lon
to_dms = (lat, lon) ->
	"?"
to_utm = (lat, lon) ->
	"?"




parse = (input) ->
	# 42.53 -4.56
	re = /\s*([-+]?\d+(\.(\d+)?)?)\s*([-+]?\d+(\.(\d+)?)?)\s*/
	m = re.exec(input)
	if m
		console.log m
		lat = parseFloat(m[1])
		lon = parseFloat(m[4])
		return (
			lat: lat
			lon: lon
		)

	# n42.53 w4.56
	re = /\s*([ns])\s*(\d+\.\d+)\s*([ew])\s*(\d+\.\d+)\s*/
	m = re.exec(input)
	if m
		lat = parseFloat(m[2])
		lon = parseFloat(m[4])
		lat = -lat  if m[1] is "s"
		lon = -lon  if m[3] is "w"
		return (
			lat: lat
			lon: lon
		)

	# w4.56 n42.53
	re = /\s*([ew])\s*(\d+\.\d+)\s*([ns])\s*(\d+\.\d+)\s*/
	m = re.exec(input)
	if m
		lat = parseFloat(m[4])
		lon = parseFloat(m[2])
		lat = -lat  if m[3] is "s"
		lon = -lon  if m[1] is "w"
		return (
			lat: lat
			lon: lon
		)


	return null


view_button = ->
	txt = $("#coords_d").textinput().val().trim().toLowerCase()
	window.location = "https://maps.google.com/maps?hl=ca&q=" + txt


convert_button = ->
	input = $("#coords").textinput().val().trim().toLowerCase()
	res = parse(input)
	lat = res.lat
	lon = res.lon
	$("#coords_d").textinput().val(to_d(lat, lon))
	$("#coords_dm").textinput().val(to_dm(lat, lon))
	$("#coords_dms").textinput().val(to_dms(lat, lon))
	$("#coords_utm").textinput().val(to_utm(lat, lon))




vell = ->
	console.log input
	console.log parse(input)
	return
	loop
		last = utm
		utm = utm.replace("  ", " ")
		utm = utm.replace(",", "")
		break  if utm is last
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

