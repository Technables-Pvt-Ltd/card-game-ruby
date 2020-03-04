import { SaveDataToStore, GetDataFromStore } from "../datastore/storagehelper";
import { User_Detail } from "../constants/constants";
import shortid from 'shortid'

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

export function GetUserData() {
    var user = GetDataFromStore(User_Detail);
    if (user == null) {
        let userid = 'user-' + shortid.generate().substring(0, 8);
        let userData = { userid: userid };

        SaveDataToStore(User_Detail, userData);

        user = GetDataFromStore(User_Detail);
    }

    return user;
}