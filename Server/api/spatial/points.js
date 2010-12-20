// http://touchcode.couchone.com:5984/anything-db/_design/geo-api/_spatial/points?bbox=-180,-90,180,90

function(doc) {
	if (doc.location) {
		var theCoordinate = doc.location.coordinate;

		var value = {id:doc._id, coordinate:[theCoordinate.longitude, theCoordinate.latitude]};

		emit({type: "Point", coordinates: [theCoordinate.longitude, theCoordinate.latitude]}, value);
		}
	}
