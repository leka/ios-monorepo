
// document.addEventListener('DOMContentLoaded', function() {
//     const currentDate = new Date().toISOString().slice(0, 16)
//     document.getElementById('created_at').value = currentDate
//     document.getElementById('last_edited_at').value = currentDate

//     // Generate UUID
        
//     const generatedUuid = uuidv4().toUpperCase().replace(/-/g, '')
//     const uuidInput = document.createElement('input')
//     uuidInput.type ='hidden'
//     uuidInput.id ='uuid';
//     uuidInput.value= generatedUuid
//     document.body.appendChild(uuidInput)
//     console.log(generatedUuid)

//     // Form submission handler
//     document.getElementById('ymlForm').addEventListener('submit', function(event) {
//         event.preventDefault()


//         const ymlData = {
//             uuid: document.getElementById('uuid').value = generatedUuid,
//             name: document.getElementById('name').value,
//             status: document.getElementById('status').value,
//             created_at: document.getElementById('created_at').value,
//             last_edited_at: document.getElementById('last_edited_at').value,
//             authors: [document.getElementById('authors').value],
//             skills: Array.from(document.getElementById('skills').selectedOptions).map(option => option.value),
//             tags: Array.from(document.getElementById('tags').selectedOptions).map(option => option.value),
//             hmi: Array.from(document.getElementById('hmi').selectedOptions).map(option => option.value),
//             locales: Array.from(document.getElementById('locales').selectedOptions).map(option => option.value),
//             activities: document.getElementById('activities').value.split(',').map(activity => activity.trim())

//         };

//         fetch('/api/generate-yml', {
//             method: 'POST',
//             headers: {
//                 'Content-Type': 'application/json',
//             },
//             body: JSON.stringify(ymlData),
//         })
//         .then(response => response.text())
//         .then(data => {
//             console.log('YML generated:', data);
//             alert('YML file generated successfully!');
//         })
//         .catch((error) => {
//             console.error('Error:', error);
//         });
//     });
// });

// function showSection(sectionId) {
//     const sections = ['section1', 'section2', 'section3'];
//     sections.forEach(id => {
//         document.getElementById(id).style.display = (id === sectionId) ? 'block' : 'none';
//     });
// }

const { v4: uuidv4 } = require('uuid'); 


const generatedUuid = uuidv4().toUpperCase().replace(/-/g, '')
// const uuidInput = document.createElement('input')
// uuidInput.type ='hidden'
// uuidInput.id ='uuid';
// uuidInput.value= generatedUuid
// document.body.appendChild(uuidInput)
console.log(generatedUuid)