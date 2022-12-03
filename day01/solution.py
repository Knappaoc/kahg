def next_elf(file) -> list[int]:
  values = []
  for content in file:
    content = content.strip()
    if content == '':
      yield values
      values = []
    else:
      values.append(int(content.strip()))
  yield values


with open("sample", mode="rt") as file:
  calories = [ sum(values) for values in next_elf(file) if len(values) > 0]

calories.sort(reverse=True)
print(f"Max calories: {calories[0]}")
print(f"Top 3 sum: {sum(calories[0:3])}")
