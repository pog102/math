function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        // Swap elements
        [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
}


function genpairs(a,b){
    const pairs = [];

    for (let i = a[0]; i <= a[1]; i++) {
        for (let j = b[0]; j <= b[1]; j++) {
            if (i >= j){
            pairs.push([i, j]);
        }}
    }
    return pairs;

}

// currentOp="+"
function operator(){
    opr = ops[Math.floor(Math.random() * ops.length)];
    document.getElementsByClassName("opr")[0].textContent=opr;

// currentOp=opr;
    
    updateAnswer();

}

function init(){
    document.getElementsByClassName("a")[0].textContent=arr[0][0];
    document.getElementsByClassName("b")[0].textContent=arr[0][1];
    operator()
    const spans = document.querySelectorAll('.c span');
    spans.forEach(span => {
        span.textContent = '\u2002'; // Invisible space but occupies space
    });
    updateAnswer();
    // ans=arr[0][0]+arr[0][1];
}
function updateAnswer() {
    const a = arr[0][0];
    const b = arr[0][1];

    switch (opr) {
        case '+':
            ans = a + b;
            break;
        case '-':
            ans = a - b;
            break;
        case '*':
            ans = a * b;
            break;
        case '/':
            ans = b !== 0 ? a / b : null;
            break;
        default:
            ans = null;
    }

    console.log('Answer:', ans);
}