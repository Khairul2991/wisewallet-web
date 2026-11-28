export function buildContactMailtoUrl(email, subject, message) {
  const cleanEmail = typeof email === 'string' ? email.trim() : '';
  const cleanSubject = typeof subject === 'string' ? subject.trim() : '';
  const cleanMessage = typeof message === 'string' ? message.trim() : '';
  if (!cleanEmail || !cleanSubject || !cleanMessage) {
    return null;
  }
  const normalizedBody = cleanMessage.replace(/\r?\n/g, '\r\n');
  return `mailto:${cleanEmail}?subject=${encodeURIComponent(cleanSubject)}&body=${encodeURIComponent(normalizedBody)}`;
}
