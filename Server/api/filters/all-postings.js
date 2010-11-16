function(doc)
	{
	return (doc._deleted || doc.type == 'posting');
	}
