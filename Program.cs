using MyBookApi.Middleware;
using MyBookApi.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();         
builder.Services.AddEndpointsApiExplorer(); 
builder.Services.AddSwaggerGen();           

builder.Services.AddSingleton<IBookService, BookService>();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseMiddleware<RequestLoggingMiddleware>();

app.MapControllers();

app.Run();
