#include "GLVertexArray.h"

GLVertexArray::GLVertexArray()
{
	m_vertexArray = 0;
}

void GLVertexArray::gen()
{
    glGenVertexArrays(1, &m_vertexArray);
}

void GLVertexArray::bind()
{
    glBindVertexArray(m_vertexArray);
}

void GLVertexArray::unbind()
{
	glBindVertexArray(0);
}

void GLVertexArray::del()
{
    glDeleteVertexArrays(1, &m_vertexArray);
}
