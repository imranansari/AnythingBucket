function(data) {
	var p;
	return {
		items : data.rows.map(function(r) {
			p = r.value
			p.attachments = [];
			if ('_attachments' in p)
				{
				for (var key in p._attachments)
					{
					var theAttachment = p._attachments[key];
					var theLink = '/anything-db/' + p._id + '/' + key;
					theAttachment["link"] = theLink;
					if (theAttachment.content_type == "image/jpeg")
						{
						theAttachment["markup"] = "<img width=100 height=100 src=" + theLink + "/>";
						}
					else if (theAttachment.content_type == "video/quicktime")
						{
						theAttachment["markup"] = "<video controls=\"controls\" width=100 height=100 src=" + theLink + "/>";
						}
					p.attachments.push(theAttachment);
					}
				}

			if ('location' in p)
				{
				try {
					p.static_map_url = 'http://maps.google.com/maps/api/staticmap?center=' + p.location.coordinate.latitude + ',' + p.location.coordinate.longitude + '&zoom=12&size=100x100&sensor=false';
					}
				catch (err)
					{
					p.static_map_url = '';
					}
				}



			$.log(p);
			return(p);
			})
	}
};


