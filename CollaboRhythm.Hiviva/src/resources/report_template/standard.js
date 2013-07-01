/*
Please note this source code constitutes proprietary software belonging to PharmiWeb Solutions and use of this proprietary software by a third party may incur a license fee. 
This source code may only be applied to projects developed on behalf of Roche Products Ltd. Prior to use please contact corporate@pharmiweb.com to request permission. 
Free reproduction and distribution of this source code is strictly prohibited.
*/

var Report = {
    Options: {
			// local properties declared here
    },
    Start: function() {
		$(window).bind('hashchange',function(){
			var newHash = window.location.hash.substring(1),
				a,
				valuePairs,
				propertyName,
				propertyValue,
				adherenceAverage = 0,
				$table = $('[data-id="adherence-table"] tbody');
				//newHash = newHash.substring(12);
				a = newHash.split("&");
				$table.append('<tr><td></td><td><strong>Adherence for this period (%)</strong></td></tr>');
				$.each(a, function(index, value) {
					valuePairs = value.split('=');
					propertyName = valuePairs[0];
					propertyValue = valuePairs[1];
					$table.append('<tr><td>' + unescape(propertyName) + '</td><td>' + unescape(propertyValue) + '</td></tr>');
					adherenceAverage += Number(propertyValue);
				});
				adherenceAverage = adherenceAverage / a.length;
				$table.append('<tr><td>Average</td><td>' + adherenceAverage + '</td></tr>');
			/*a = newHash.split("&")
			$.each(a, function(index, value) {
				valuePairs = value.split('=');
				propertyName = valuePairs[0];
				propertyValue = valuePairs[1];
				$('[data-id="' + propertyName + '"]').append(unescape(propertyValue));
			});*/
		});
    }
};

Report.Start();
/*
Please note this source code constitutes proprietary software belonging to PharmiWeb Solutions and use of this proprietary software by a third party may incur a license fee. 
This source code may only be applied to projects developed on behalf of Roche Products Ltd. Prior to use please contact corporate@pharmiweb.com to request permission. 
Free reproduction and distribution of this source code is strictly prohibited.
*/