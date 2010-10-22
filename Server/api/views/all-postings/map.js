function(doc)
	{
	if (doc.type == 'posting')
		emit(null, doc);
	}
