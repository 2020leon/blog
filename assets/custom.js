(function () {
	var h2 = document.querySelectorAll('article h2');
	var h3 = document.querySelectorAll('article h3');
	var linkList = document.querySelectorAll('#TableOfContents a');

	function findLinkElement(name) {
		for (var i = 0; i < linkList.length; i++) {
			var items = linkList[i].href.split('#');
			if (items && items[items.length - 1] === encodeURIComponent(name)) {
				return i;
			}
		}
		return -1;
	}

	function activeLink(titleList) {
		var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
		for (var i = titleList.length - 1; i >= 0; i--) {
			var style = titleList[i].currentStyle || window.getComputedStyle(titleList[i]);
			if (scrollTop - titleList[i].offsetTop >= -parseFloat(style.marginTop)) {
				var index = findLinkElement(titleList[i].id);
				if (index != -1) {
					var greatGrandparent = linkList[index].parentElement.parentElement.parentElement;
					if (greatGrandparent.tagName == 'NAV') {
						linkList[index].parentElement.classList.add('active');
					}
					else if (greatGrandparent.classList.contains('active')) {
						linkList[index].parentElement.classList.add('active');
					}
				}
				break;
			}
		}
	}

	window.addEventListener("scroll", function () {
		[].slice.call(linkList).forEach(function (link) {
			link.parentElement.classList.remove('active');
		})
		activeLink(h2);
		activeLink(h3);
	})
})();