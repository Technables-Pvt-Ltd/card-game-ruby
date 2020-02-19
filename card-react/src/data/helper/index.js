/*
    replace url param with value
    param:
        pathRegex: url that need to be replaced with param value (eg http://example.com/page/:id/article/:title)
        params: the object with value of params eg ({id: 1, title: 'reactjs'})
    output:
        final url with replaced param (eg http://example.com/page/1/article/reactjs)
*/

export function replaceParam(pathRegex, params) {
    var segments = pathRegex.split('/');
    return segments.map(segment => {
        var offset = segment.indexOf(':') + 1;
        if (!offset) return segment;

        var key = segment.slice(offset);
        return params[key];
    })
        .join('/');
}

/*
    Get random value from an array
*/
export function GetRandom(array) {
    return array[Math.floor((Math.random() * array.length))];
}