

/*
    Save any value to local storage
    params:
        key: key for value for future reference
        value: value to be saved
*/

export function SaveDataToStore(key, value) {
    if (value) {
        value = JSON.stringify(value);
        localStorage.setItem(key, value);
    }
}
/*
    Retrieve any data stored in local storage
    param:
        key: key for which value is to be retrieved from storage
*/
export function GetDataFromStore(key) {
    var data = localStorage.getItem(key);
    try {
        data = data ? JSON.parse(data) : null;
    } catch (error) {
        data = null;
    }

    return data;
}

/*
    Remove any data stored in local storage
    param:
        key: key for which value is to be removed from storage
*/
export function RemoveDataFromStorage(key) {
    if (localStorage.getItem(key) !== null)
        localStorage.removeItem(key);
}

