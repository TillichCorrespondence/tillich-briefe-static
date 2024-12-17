import { register } from "../vendor/calendar-component/calendar.js";
import de from "../vendor/calendar-component/i18n/de.js";


register({});
// register()

function createCalendar(i18n, events, onEventClick) {
    const calendar = document.querySelector("acdh-ch-calendar");

    if (i18n != null) {
        /** Optionally set locale, defaults to english. */
        calendar.setI18n(i18n);
    }

    calendar.setData({ events, currentYear: 1920 });

    calendar.addEventListener("calendar-event-click", onEventClick);
}

function onEventClick(event) {
    var myModal = new bootstrap.Modal(document.getElementById("dataModal"), {});

    const { date, events } = event.detail;
    const modalBody = document.querySelector('#dataModal .modal-body');
    modalBody.innerHTML = "";
    const myUl = document.createElement("ul")

    events.forEach(item => {
        const li = document.createElement("li");
        if (item.link) {
            li.innerHTML = `
                <a href="${item.link}">${item.label}</a>
            `
        } else {
            li.innerHTML = `${item.label}`
        }

        myUl.appendChild(li)
    });
    modalBody.appendChild(myUl)
    myModal.show()
}

async function request(url) {
    const response = await fetch(url);
    const events = await response.json();
    return events.map((event) => {
        return { ...event, date: new Date(event.date) };
    });
}

try {
    const events = await request("js-data/calendarData.json");
    createCalendar(de, events, onEventClick);
    console.log("Successfully created calendar.");
    document.querySelectorAll('label').forEach(label => {
        if (label.querySelector('input[disabled]')) {
            label.classList.add('visually-hidden');
        }
    });
    
    
} catch (error) {
    console.error("Failed to create calendar.\n", String(error));
}