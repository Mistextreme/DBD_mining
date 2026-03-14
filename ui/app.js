const overlay = document.getElementById("overlay");
const rowsContainer = document.getElementById("rows");
const emptyState = document.getElementById("empty");
const closeButton = document.getElementById("close");

const taskOverlay = document.getElementById("task-overlay");
const taskCurrent = document.getElementById("task-current");
const taskCurrentName = document.getElementById("task-current-name");
const taskProgress = document.getElementById("task-progress");
const taskListWrap = document.getElementById("task-list-wrap");
const taskList = document.getElementById("task-list");
const taskHandInBtn = document.getElementById("task-handin");
const taskCancelBtn = document.getElementById("task-cancel");
const taskCloseBtn = document.getElementById("task-close");

const taskProgressWidget = document.getElementById("task-progress-widget");
const taskWidgetLines = document.getElementById("task-widget-lines");

let taskData = { tasks: {}, currentTaskId: null, counts: {} };
let lastProgressWidgetKey = "";

function escapeHtml(str) {
  if (str == null || str === undefined) return "";
  const div = document.createElement("div");
  div.textContent = String(str);
  return div.innerHTML;
}

function clearRows() {
  rowsContainer.innerHTML = "";
}

function showRows(rows, sortKey) {
  clearRows();
  if (!rows || rows.length === 0) {
    emptyState.classList.remove("hidden");
    return;
  }
  emptyState.classList.add("hidden");
  rows.forEach((row, index) => {
    const entry = document.createElement("div");
    entry.className = "row";
    entry.innerHTML = `
      <div class="cell rank">${index + 1}</div>
      <div class="cell name">${escapeHtml(row.name ?? "Unknown")}</div>
      <div class="cell xp">${row.xp ?? 0}</div>
      <div class="cell level">${row.level ?? 1}</div>
      <div class="cell ores">${row.total_ores ?? 0}</div>
    `;
    rowsContainer.appendChild(entry);
  });
}

function openUi(rows, sortKey) {
  overlay.classList.remove("hidden");
  overlay.style.display = "flex";
  showRows(rows, sortKey);
}

function closeUi() {
  overlay.classList.add("hidden");
  overlay.style.display = "none";
  clearRows();
}

function post(eventName, payload = {}) {
  fetch(`https://${GetParentResourceName()}/${eventName}`, {
    method: "POST",
    headers: { "Content-Type": "application/json; charset=UTF-8" },
    body: JSON.stringify(payload),
  });
}

function formatItemName(item) {
  if (!item) return "";
  return item
    .replace(/_/g, " ")
    .replace(/\b\w/g, (c) => c.toUpperCase());
}

function updateTaskProgressWidget(visible, progressLines) {
  if (!taskProgressWidget || !taskWidgetLines) return;
  if (!visible || !progressLines || progressLines.length === 0) {
    taskProgressWidget.classList.add("hidden");
    lastProgressWidgetKey = "";
    return;
  }
  const key = JSON.stringify(progressLines);
  if (key === lastProgressWidgetKey) return;
  lastProgressWidgetKey = key;
  taskProgressWidget.classList.remove("hidden");
  // Show only XXXX/XXXX in the slot (single counter, no ore name)
  const line = progressLines[0];
  const current = line?.current ?? 0;
  const required = line?.required ?? 0;
  const done = current >= required;
  taskWidgetLines.innerHTML = `<span class="counter-value ${done ? "done" : ""}">${current}/${required}</span>`;
}

function buildTaskProgress(task, counts) {
  if (!task || !task.requirements) return "";
  return task.requirements
    .map((req) => {
      const have = counts[req.item] ?? 0;
      const need = req.amount ?? 0;
      const done = have >= need;
      const name = escapeHtml(formatItemName(req.item));
      return `<span class="${done ? "done" : "pending"}">${name}: ${Math.min(have, need)}/${need}</span>`;
    })
    .join("<br/>");
}

function canHandIn(task, counts) {
  if (!task || !task.requirements) return false;
  return task.requirements.every((req) => (counts[req.item] ?? 0) >= (req.amount ?? 0));
}

function renderTaskList() {
  taskList.innerHTML = "";
  const tasks = taskData.tasks || {};
  const currentId = taskData.currentTaskId;
  const ids = Object.keys(tasks)
    .map(Number)
    .filter((id) => !isNaN(id))
    .sort((a, b) => a - b);
  ids.forEach((id) => {
    const task = tasks[id];
    if (!task || task.id === currentId) return;
    const reqs = (task.requirements || [])
      .map((r) => `${escapeHtml(formatItemName(r.item))}: ${r.amount}`)
      .join(", ");
    const div = document.createElement("div");
    div.className = "task-item";
    div.dataset.taskId = id;
    div.innerHTML = `
      <div class="task-item-name">${escapeHtml(task.label ?? "Task " + id)}</div>
      <div class="task-item-reqs">${reqs}</div>
      <div class="task-item-xp">+${task.xp ?? 0} XP</div>
    `;
    div.addEventListener("click", () => post("taskAccept", { taskId: id }));
    taskList.appendChild(div);
  });
}

function openTaskUi(data) {
  taskData = {
    tasks: data.tasks || {},
    currentTaskId: data.currentTaskId ?? null,
    counts: data.counts || {},
  };
  const currentId = taskData.currentTaskId;
  const currentTask = currentId != null ? taskData.tasks[currentId] : null;

  if (currentTask) {
    taskCurrent.classList.remove("hidden");
    taskCurrentName.textContent = currentTask.label ?? "Task";
    taskProgress.innerHTML = buildTaskProgress(currentTask, taskData.counts);
    taskHandInBtn.disabled = !canHandIn(currentTask, taskData.counts);
    taskListWrap.classList.add("hidden");
  } else {
    taskCurrent.classList.add("hidden");
    taskListWrap.classList.remove("hidden");
    renderTaskList();
  }

  taskOverlay.classList.remove("hidden");
  taskOverlay.style.display = "flex";
}

function closeTaskUi() {
  taskOverlay.classList.add("hidden");
  taskOverlay.style.display = "none";
  taskData = { tasks: {}, currentTaskId: null, counts: {} };
}

window.addEventListener("message", (event) => {
  const payload = event.data || {};
  const { action, rows, sortKey, tasks, currentTaskId, counts, showProgressWidget, progressLines } = payload;
  if (action === "open") {
    openUi(rows || [], sortKey || "xp");
  } else if (action === "close") {
    closeUi();
  } else if (action === "openTasks") {
    const data = { tasks: tasks || {}, currentTaskId: currentTaskId ?? null, counts: counts || {} };
    if (currentTaskId != null) {
      updateTaskProgressWidget(true, progressLines && progressLines.length > 0 ? progressLines : []);
    } else {
      updateTaskProgressWidget(false);
    }
    openTaskUi(data);
  } else if (action === "updateTaskProgress") {
    const { showProgressWidget: vis, progressLines: lines } = payload;
    updateTaskProgressWidget(!!vis, lines || []);
  } else if (action === "closeTasks") {
    closeTaskUi();
  }
});

closeButton.addEventListener("click", () => post("close"));
taskCloseBtn.addEventListener("click", () => post("closeTasks"));
taskHandInBtn.addEventListener("click", () => post("taskHandIn"));
taskCancelBtn.addEventListener("click", () => post("taskCancel"));

document.addEventListener("keydown", (event) => {
  if (event.key === "Escape") {
    if (!taskOverlay.classList.contains("hidden")) {
      post("closeTasks");
    } else {
      post("close");
    }
  }
});

closeUi();
closeTaskUi();
