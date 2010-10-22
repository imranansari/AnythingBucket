function(data) {
	var p;
	return {
		items : data.rows.map(function(r) {
			p = r.value
			if ('_attachments' in p)
				{
				p.attachment = p._id + '/' + 'attachment';
				}
			else
				{
				p.attachment = null;
				}
			if ('location' in p)
				{
				p.static_map_url = 'http://maps.google.com/maps/api/staticmap?center=' + p.location.latitude + ',' + p.location.longitude + '&zoom=12&size=100x100&sensor=false';
				}
			$.log(p);
			return(p);
			})
	}
};


