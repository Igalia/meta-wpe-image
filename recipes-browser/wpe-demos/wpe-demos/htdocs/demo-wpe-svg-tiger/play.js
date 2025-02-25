const pages = ["igalia.html", "rotations.html", "transformations.html"]

function playKey(e)
{
    const video = document.querySelector("video");
    switch (e.code) {
        case "Enter":
        case "KeyN":
            playNext();
            break;
        case "KeyP":
            playPrevious();
            break;
    }
}

function playPrevious()
{
    let url = window.location.pathname;
    let filename = url.substring(url.lastIndexOf('/')+1);
    let index = pages.indexOf(filename);

    if (index < 1)
    {
        index = pages.length - index;
    }

    let previous = (index - 1) % pages.length;
    window.location = pages[previous];
}

function playNext()
{
    let url = window.location.pathname;
    let filename = url.substring(url.lastIndexOf('/')+1);
    let index = pages.indexOf(filename);
    let next = (index + 1) % pages.length;
    window.location = pages[next];
}

function playInit(timeout)
{
    fetch("../LAYER_BASED_SVG_ENGINE_TOGGLER", { method: "HEAD" })
        .then(function (response) {
            if (response.ok) {
                t = document.getElementById("title");
                t.innerHTML = t.innerHTML + " (LBSE enabled)";
            } else {
                t = document.getElementById("title");
                t.innerHTML = t.innerHTML + " (LBSE disabled)";
            }
        })
        .catch(error => {
            console.log("An error occurred: ", error);
        });

    setTimeout(playNext, timeout);

    document.addEventListener('keyup', playKey, false);
}
