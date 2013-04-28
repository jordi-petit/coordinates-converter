
# Returns the string corresponding to lat,lon in d format.
to_d = (lat, lon) ->
	lat_pos = if lat >= 0 then 'N' else 'S'
	lat_deg = Math.abs(lat)
	lat = lat_pos + ' ' + lat_deg.toFixed(6)

	lon_pos = if lon >= 0 then 'E' else 'W'
	lon_deg = Math.abs(lon)
	lon = lon_pos + ' ' + lon_deg.toFixed(6)

	return lat + ' ' + lon


# Returns the string corresponding to lat,lon in dm format.
to_dm = (lat, lon) ->
	lat_pos = if lat >= 0 then 'N' else 'S'
	lat = Math.abs(lat)
	lat_deg = Math.floor(lat)
	lat_min = 60 * (lat - lat_deg)
	lat = lat_pos + ' ' + lat_deg + '° ' + lat_min.toFixed(3) + '\''

	lon_pos = if lon >= 0 then 'E' else 'W'
	lon = Math.abs(lon)
	lon_deg = Math.floor(lon)
	lon_min = 60 * (lon - lon_deg)
	lon = lon_pos + ' ' + lon_deg + '° ' + lon_min.toFixed(3) + '\''

	return lat + ' ' + lon


# Returns the string corresponding to lat,lon in dms format.
to_dms = (lat, lon) ->
	lat_pos = if lat >= 0 then 'N' else 'S'
	lat = Math.abs(lat)
	lat_deg = Math.floor(lat)
	lat_min_f = 60 * (lat - lat_deg)
	lat_min_i = Math.floor(lat_min_f)
	lat_sec = 60 * (lat_min_f - lat_min_i)
	lat = lat_pos + ' ' + lat_deg + '° ' + lat_min_i + '\' ' + lat_sec.toFixed(3) + '"'

	lon_pos = if lon >= 0 then 'E' else 'W'
	lon = Math.abs(lon)
	lon_deg = Math.floor(lon)
	lon_min_f = 60 * (lon - lon_deg)
	lon_min_i = Math.floor(lon_min_f)
	lon_sec = 60 * (lon_min_f - lon_min_i)
	lon = lon_pos + ' ' + lon_deg + '° ' + lon_min_i + '\' ' + lon_sec.toFixed(3) + '"'

	return lat + ' ' + lon


# Returns the string corresponding to lat,lon in utm format.
# Not yet implemented
to_utm = (lat, lon) ->
	return '?'




parse = (input) ->
	# 42.53 -4.56
	re = /\s*([-+]?\d+(\.(\d+)?)?)\s+([-+]?\d+(\.(\d+)?)?)\s*/
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
	re = /\s*([ns])\s*(\d+\.\d+)\s+([ew])\s*(\d+\.\d+)\s*/
	m = re.exec(input)
	if m
		lat = parseFloat(m[2])
		lon = parseFloat(m[4])
		lat = -lat  if m[1] is 's'
		lon = -lon  if m[3] is 'w'
		return (
			lat: lat
			lon: lon
		)

	# w4.56 n42.53
	re = /\s*([ew])\s*(\d+\.\d+)\s+([ns])\s*(\d+\.\d+)\s*/
	m = re.exec(input)
	if m
		lat = parseFloat(m[4])
		lon = parseFloat(m[2])
		lat = -lat  if m[3] is 's'
		lon = -lon  if m[1] is 'w'
		return (
			lat: lat
			lon: lon
		)


	return null


view_button = ->
	txt = $('#coords_d').textinput().val().trim().toLowerCase()
	window.location = 'https://maps.google.com/maps?hl=ca&q=' + txt


convert_button = ->
	input = $('#coords').textinput().val().trim().toLowerCase()
	res = parse(input)
	if res
		lat = res.lat
		lon = res.lon
		$('#coords_d').textinput().val(to_d(lat, lon))
		$('#coords_dm').textinput().val(to_dm(lat, lon))
		$('#coords_dms').textinput().val(to_dms(lat, lon))
		$('#coords_utm').textinput().val(to_utm(lat, lon))
		$('#view').button('enable')
	else
		$('#coords_d').textinput().val('')
		$('#coords_dm').textinput().val('')
		$('#coords_dms').textinput().val('')
		$('#coords_utm').textinput().val('')
		$('#view').button('disable')


init = ->
	navigator.geolocation.getCurrentPosition (location) ->
		lat = location.coords.latitude
		lon = location.coords.longitude
		$('#coords').textinput().val(to_d(lat, lon))
		$('#coords_d').textinput().val(to_d(lat, lon))
		$('#coords_dm').textinput().val(to_dm(lat, lon))
		$('#coords_dms').textinput().val(to_dms(lat, lon))
		$('#coords_utm').textinput().val(to_utm(lat, lon))
		$('#view').button('enable')


vell = ->
	console.log input
	console.log parse(input)
	return
	loop
		last = utm
		utm = utm.replace('  ', ' ')
		utm = utm.replace(',', '')
		break  if utm is last
	x = parseFloat(utm.split(' ')[0])
	y = parseFloat(utm.split(' ')[1])
	zone = 31
	southhemi = false
	latlon = new Array(2)
	UTMXYToLatLon x, y, zone, southhemi, latlon
	lat = RadToDeg(latlon[0])
	lon = RadToDeg(latlon[1])
	document.f.gps_d.value = to_d(lat, lon)
	document.f.gps_dm.value = to_dm(lat, lon)
	document.f.gps_dms.value = to_dms(lat, lon)

