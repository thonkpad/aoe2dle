class Ok {
    constructor(value) {
        this.tag = "Ok";
        this.value = value;
    }
}

class Error {
    constructor(error) {
        this.tag = "Error";
        this.error = error;
    }
}

export function read(key) {
    const value = window.localStorage.getItem(key);
    return value ? new Ok(value) : new Error(undefined)
}

export function write(key, value) {
    window.localStorage.setItem(key, value);
}
