window.addEventListener('DOMContentLoaded', () => {

	const observer = new IntersectionObserver(entries => {
		entries.forEach(entry => {
			const id = entry.target.getAttribute('id');
			if (entry.intersectionRatio > 0) {
				document.querySelector(`nav li a[href="#${id}"]`).parentElement.classList.add('active');
			} else {
				document.querySelector(`nav li a[href="#${id}"]`).parentElement.classList.remove('active');
			}
		});
	});

	// Track all sections that have an `id` applied
	document.querySelectorAll('h2[id],h3[id],h4[id],h5[id]').forEach((section) => {
		observer.observe(section);
	});
	
});

function clearActiveStatesInTableOfContents() {
    document.querySelectorAll('aside nav li').forEach((section) => {
        section.classList.remove('active');
    });
}